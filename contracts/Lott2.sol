// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Lottery {
    address public owner;
    address payable[] public players;
    address public winner; 

    constructor() {
        owner = msg.sender;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum 0.01 ether to enter");
        players.push(payable(msg.sender));
    }

    function getRandomNum() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner {
        require(players.length > 0, "No players in the lottery");

        uint index = getRandomNum() % players.length; 
        winner = players[index];                      
        players[index].transfer(address(this).balance); //  Transfer prize
        players = new address payable[](0) ;           //  Reset players
    }

    function getWinner() public view returns (address) {
        return winner; // Returns the last winner’s address
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}


