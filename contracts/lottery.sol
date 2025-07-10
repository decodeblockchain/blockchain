// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Lottery
{
    address public manager;
    uint public playerCount;
    uint public entryFee;
    address public winner;

    mapping(uint => address) public players;

    //@noitce Emitted when a player joins
    event Joined(address player, uint playerCount);

    //@notice Emitted when a winner is picked
    event WinnerPick(address winner, uint playerCount);

    constructor() {
        manager=msg.sender;
    }

    //@notice Allow the player to join the lottery
    function join() public payable {
        if(msg.value == entryFee) {
            players[playerCount] = msg.sender;
            emit Joined(msg.sender, playerCount);
            playerCount++;
        }
    }

    //@notice Allow the manager to select a random winner
    function selectWinner() public {
        if(msg.sender != manager){
            revert("Only manager can select");
        }
        if(playerCount == 0){
            revert("No player enterd");
        }

        uint luckyNum = block.prevrandao % playerCount;
        winner = players[luckyNum];

        emit WinnerPick(winner, playerCount);

        payable(winner).transfer(address(this).balance);
    }

    //@notice return the current balance of the contract
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
}