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

    event TransferComplete(
        address indexed from, address indexed to, string message,uint amount, uint timestamp 
    );

    constructor (){
        owner = msg.sender;
    }

    modifier OnlyOwner(uint i){
        require(i < accounts[msg.sender].length, "Not Valid account index");
        _;
    }

    function deposit(uint i, uint amount) public OnlyOwner(i){
        if (accounts[msg.sender].length == 0){
            accounts[msg.sender].push(Account({id: msg.sender, balance:0, timestamp:block.timestamp}));
        }
        require(i < accounts[msg.sender].length, "Account id invalid");
       accounts[msg.sender][i].balance += amount;
    }

    function withdraw(uint i, uint amount) public OnlyOwner(i){
        require(i < accounts[msg.sender].length, "Account id invalid");
        require(accounts[msg.sender][i].balance >= amount, "Insufficent funds");
        accounts[msg.sender][i].balance -= amount;
    }

    function transfer(uint i, address receiver, uint amount, string memory message) public OnlyOwner(i){
        require(i < accounts[msg.sender].length, "Account id invalid");
        require(accounts[msg.sender][i].balance >= amount, "Insufficient funds");
        require(receiver != msg.sender, "Invalid account");

        accounts[msg.sender][i].balance -= amount;

        if (accounts[receiver].length == 0){
            accounts[receiver].push(Account({id: receiver, balance:0, timestamp:block.timestamp}));
        } else {
            accounts[receiver][0].balance += amount;
        }
        
        emit TransferComplete(msg.sender, receiver, message, amount, block.timestamp);

    }

    function getBalance(uint i) public view returns(uint){
        require(i < accounts[msg.sender].length, "Account id invalid");
        return accounts[msg.sender][i].balance;
    }

}