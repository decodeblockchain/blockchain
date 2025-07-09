// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Lottery {
    address public owner;
    address payable[] public players;
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
        require(msg.value > 0.01 ether);
        players.push(payable(msg.sender));
    }
    function getRandomNum() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }
    function pickWinner() public onlyOwner {
        require(players.length > 0);
        uint index = getRandomNum() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0) ;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

