// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    
    /* Declare State variables */
    address admin;
    address winner;
    uint256 winningAmount = 0 ether;
    uint256 totalContractValue = 0 ether;

    address[] public user;

    mapping(uint256 => address) userRecords;


    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin should be here");
        _;
    }

    modifier onlyWinner(){
        require(msg.sender == winner, "Only winner should be here");
        _;
    }
    
    /* Declare events */

    constructor() {
        admin = msg.sender;
    }

	// Pass some ether to this function and enter the lottery
    function enter() external payable {
        require(msg.value > 0, "Ether value should be greater than zero");
        totalContractValue += msg.value;
        user.push(msg.sender);
    }

    function claimReward() external onlyWinner {
        winningAmount = 0;
        winner = address(0);
        (bool sent, ) = msg.sender.call{value: winningAmount}("");
        require(sent, "Failed to send Ether");
    }
    
    function decideWinner() public onlyAdmin returns(address) {
        uint256 random_userId = random() % (user.length) + 1;
        winner = userRecords[random_userId];
        winningAmount = totalContractValue;
        user = new address[](0);
        totalContractValue = 0;
        return winner;
    }

    function listOfParticipants() public view returns(address[] memory) {
        return user;
    }

    function random() private view onlyAdmin returns(uint) {
        // Below function generates pseudorandom uint based on admin and block.timestamp
        return uint(keccak256(abi.encodePacked(admin, block.timestamp)));
    }
}