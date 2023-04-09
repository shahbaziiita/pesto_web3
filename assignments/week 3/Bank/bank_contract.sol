//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract bankContract {
    mapping(address => uint)public balances;
    bool public reentrancyLock;

    event depositAmount(address indexed accountAddress, uint amount);
    event withdrawAmount(address indexed accountAddress, uint amount);
    event transferAmount(address indexed fromAddress, address indexed toAddress, uint amount);

    function deposit() public payable {
        require(msg.value > 0, "Value for deposit is Zero");
        require(!reentrancyLock);
        reentrancyLock = true;
        balances[msg.sender] += msg.value;
        reentrancyLock = false;
        emit depositAmount(msg.sender, msg.value);

    }

    function withdraw(uint _amount) public payable {
        require (balances[msg.sender]>= _amount, "Insufficent Funds");
        require(_amount > 0, "Enter non-zero value for sending");
        balances[msg.sender] = balances[msg.sender] - _amount;
        (bool sent,) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to Complete");
        emit withdrawAmount(msg.sender, msg.value);
    }

    function transfer(address payable recipient_address, uint _amount) public {
        require (balances[msg.sender]>= _amount, "Insufficent Funds");
        require(_amount > 0, "Enter non-zero value for sending");
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[recipient_address] = balances[recipient_address] + _amount;
        emit transferAmount(msg.sender, recipient_address, _amount);
    }

    function getBalance() public view returns(uint) {
       return balances[msg.sender];
    }


}