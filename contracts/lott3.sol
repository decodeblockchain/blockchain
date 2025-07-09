// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Lottry {
    address public owner;
    address public winner;
    uint256 public participantCount;

// enum keeps track of the state of the lottery
    enum LotteryState { OPEN, CLOSED }
    LotteryState public state;

    mapping(uint256 => address payable) private participants;

// the deployer of the contract is the owner 
// initially the state of the lottery is set to open
    constructor() {
        owner = msg.sender;
        state = LotteryState.OPEN; // Start with lottery open
    }

//Enter function lets the particpants to enroll in the lottery
//check weather the lottery is open or not using the state of the lottery and also checks for the the entry fees 
    
    function enter() external payable {
        // Check if lottery is open
        if (state == LotteryState.CLOSED) {
            revert("Lottery is not open");
        }

        //Check entry fee
        if (msg.value < 0.01 ether) {
            revert("Min entry fee is 0.01 ether");
        }

        //Add participant and incrrease the participants count
        participants[participantCount] = payable(msg.sender); 
        participantCount += 1;
    }
// only owner can pick a winner and check the participants counts if its 0 the lottery wont pick a winner
// also check for the lottery state
    function pickWinner() external {
        // Only owner can pick winner
        if (msg.sender != owner) {
            revert("Only owner can pick winner");
        }

        // Check if there are participants
        if (participantCount == 0) {
            revert("No participants in the lottery");
        }

        // Check if lottery is open
        if (state == LotteryState.CLOSED) {
            revert("Lottery is already closed");
        }

        //Get random index by dividing the block.prevrandao to the participants counts
        uint256 index = uint256(block.prevrandao) % participantCount;
        winner = participants[index];

        //Transfer balance to winner
        //Get the contract balance
        uint256 contractBalance = address(this).balance;

        //Transfer balance to winner
        payable(winner).transfer(contractBalance);
        
        //Close the lottery state when the amount is transferred
        state = LotteryState.CLOSED;
        
        // Reset the lottry and start the lottery state
        participantCount = 0;
        state = LotteryState.OPEN;
    }
}
