// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CleanLottery {
    address public owner;
    uint256 public entryFee;
    uint256 public maxPlayers;
    uint256 public playerCount;
    uint256 public round;

    struct Player {
        address account;
        uint roundEntered;
    }

    mapping(address => Player) public participant;
    mapping(uint => address) private indexedPlayers;

    event Entered(address indexed player, uint index);
    event WinnerPicked(address indexed winner, uint prize);
    event TransferFailed(address indexed to, uint amount);

    constructor(uint _maxPlayers, uint _entryFee) {
        owner = msg.sender;
        maxPlayers = _maxPlayers;
        entryFee = _entryFee;
        round = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function entry() external payable {
     
        participant[msg.sender] = Player(msg.sender, round);
        indexedPlayers[playerCount] = msg.sender;

        emit Entered(msg.sender, playerCount);

        playerCount++;
    }

    function pickWinner() external  {
        uint randomIndex = uint(block.prevrandao) % maxPlayers;    // generate one random index number and we assume that index is winner 
        address winner = indexedPlayers[randomIndex];                    // assign index in winner variable
        uint prize = address(this).balance;                              // assign balance into price variable 
 
        (bool success, ) = payable(winner).call{value: prize}("");      // send the winning amount 
        if (!success) {
            emit TransferFailed(winner, prize);          // failed
        }
        emit WinnerPicked(winner, prize);                                   

        playerCount = 0;
        round++; 
    }


    function getPlayerByIndex(uint index) external view returns (address) {
        return indexedPlayers[index];
    }

    
}