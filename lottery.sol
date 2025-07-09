// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimpleLottery {
    address public owner;                      // Contract owner
    uint public fee;                           // Entry fee 
    uint public playerCount;                   // Number of players in current round
    uint public lotteryId;                     // Tracks the lottery round

    mapping(uint => address) public players;   // Stores players
    mapping(uint => address) public winners;   // Stores winners by round

    constructor(uint _fee) {
        owner = msg.sender;    // Set contract as owner
        fee = _fee;            // Set entry fee
        playerCount = 0;
        lotteryId = 1;
    }

    // Player joins the lottery by paying fee
    function join() public payable {
        if (msg.value == fee) {
            players[playerCount] = msg.sender;
            playerCount++;
        } else {
            // Refund if incorrect fee sent
            payable(msg.sender).transfer(msg.value);
        }
    }

    // Owner conducts the lottery and picks a winner
    function conductLottery() public {
        if (msg.sender == owner) {
            if (playerCount > 0) {
                uint luckyNumber = block.prevrandao % playerCount;
                address winner = players[luckyNumber];

                // Transfer winning amount
                payable(winner).transfer(address(this).balance);

                // Record winner 
                winners[lotteryId] = winner;

                // Reset for next round
                playerCount = 0;
                lotteryId++;
            }
        }
    }

    // Only owner can view contract balance
    function getBalance() public view returns (uint) {
        if (msg.sender == owner) {
            return address(this).balance;
        } else {
            return 0;
        }
    }
}