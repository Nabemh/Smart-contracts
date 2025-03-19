// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transactions{

    struct Account{
        uint balance;
        uint timestamp;
        address id;
    }

    mapping (address => Account[]) public accounts;
    address public owner;

    event TranserComplete(
        address indexed from, address indexed to, string message,uint amount, uint timestamp 
    );

    constructor (){
        owner = msg.sender;
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

    function deposit(uint i, uint amount) public OnlyOwner{
        require(i < accounts[msg.sender].length, "Accound id invalid");
       accounts[msg.sender][i].balance += amount;
    }

    function withdraw(uint i, uint amount) public OnlyOwner{
        require(i < accounts[msg.sender].length, "Accound id invalid");
        require(accounts[msg.sender][i].balance >= amount, "Insufficent funds");
        accounts[msg.sender][i].balance -= amount;
    }

    function transfer(uint i, address receiver, uint amount, string memory message) public OnlyOwner{
        require(i < accounts[msg.sender].length, "Accound id invalid");
        require(accounts[msg.sender][i].balance >= amount, "Insufficient funds");
        require(receiver != accounts[msg.sender][i].id, "Invalid account");

        withdraw(i, amount);
        accounts[receiver][i].balance += amount;
        emit TranserComplete(accounts[msg.sender][i].id, accounts[receiver][i].id, message, amount, accounts[msg.sender][i].timestamp);

    }

    function getBalance(uint i) public view returns(uint){
        return accounts[msg.sender][i].balance;
    }

}