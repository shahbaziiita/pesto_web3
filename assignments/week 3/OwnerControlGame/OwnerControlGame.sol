// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract OwnerControlGame{
    address owner;
    uint256 contractValue;
    uint256 public previousOwnerDeposits;
    uint256 public minThresholdETH = 1 ether;
    
    struct User{
        address userAddress;
        uint256 userId;
        bool isRegistered;
        uint256 balance;
    }

    mapping(address => User) public userRecords;

    event OwnerChanged(address indexed oldOwner, address indexed newOwner, uint256 indexed timestamp);
    event NewUserRegistered(address indexed _user, uint256 indexed _userId, uint256 indexed timestamp);

    modifier checkUser(address _userAddress){
        require(_userAddress == msg.sender, "Impersonating user - Bad call");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Caller is not Owner");
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner, "Caller is Owner");
        _;
    }

    constructor() payable{
        // Want to check if ETHER provided is 1 or more than - If not, revert
        require(msg.value >= minThresholdETH, "Invalid Amount Passed");
        // If success - make the deployer as the owner.
        owner = msg.sender;
        // If success - initialize contract's value as whatever value is passed by deployer
        contractValue = msg.value;
        previousOwnerDeposits = msg.value;
    }

    function getOwner() external view returns(address){
        return owner;
    }

    function getContractValue() external view returns(uint256){
        return contractValue;
    }

    function setContractValue() external onlyOwner() payable{
        require(msg.value > previousOwnerDeposits, "Invalid amount");
        User storage user = userRecords[msg.sender];
        user.balance += msg.value;
        contractValue += msg.value;
    }

    function register(address _userAddress, uint256 _id) external checkUser(_userAddress){
        User memory newUser;

        newUser.userAddress = _userAddress;
        newUser.userId = _id;
        newUser.isRegistered = true;

        userRecords[msg.sender] = newUser;

        emit NewUserRegistered(msg.sender, _id, block.timestamp);
    }

    function makeMeAdmin() external payable{
        User storage user = userRecords[msg.sender];

        require(user.isRegistered, "User is not registered");
        require(msg.value > previousOwnerDeposits,"Less deposit than prev owner");

        user.balance = msg.value;

        address oldOwner = owner;
        owner = msg.sender;
        previousOwnerDeposits = msg.value;
        contractValue += msg.value;

        emit OwnerChanged(oldOwner, msg.sender, block.timestamp);
    }

    function withDrawFunds(address _userAddress) external checkUser(msg.sender) notOwner() {
        User storage user = userRecords[_userAddress];
        user.isRegistered = false;
        uint256 amount = user.balance;
        contractValue -= amount;
        user.balance = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to withdraw Ether");
    }

}