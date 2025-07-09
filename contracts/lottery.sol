// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimpleLottery{

    address public owner;
    uint public fee;
    uint public playerCount;
    uint public lotteryId;

    mapping(uint => address) public players;
    mapping(uint => address) public winners;

    constructor(uint _fee){
        owner = msg.sender;
        fee = _fee;
        playerCount = 0;
        lotteryId = 1;
    }

    function join() public payable {
        if (msg.value == fee) {
            players[playerCount] = msg.sender;
            playerCount = playerCount + 1;
        }
    }

    function conductLottery() public {
        if (msg.sender == owner) {
            if (playerCount > 0) {
              
                uint luckyNumber = block.prevrandao % playerCount;
                address winner = players[luckyNumber];

                payable(winner).transfer(address(this).balance);

                winners[lotteryId] = winner;

                playerCount = 0;
                lotteryId++;
            }
        }
    }

    function getBalance() public view returns (uint) {
        if (msg.sender == owner) {
            return address(this).balance;
        } else {
            return 0;
        }
    }
}


