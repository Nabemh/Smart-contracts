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

    

    constructor (){
        owner == msg.sender;
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

    function deposit(uint i, uint amount) public OnlyOwner{
       accounts[msg.sender][i].balance += amount;
    }

    function withdraw(uint i, uint amount) public OnlyOwner{
        require(accounts[msg.sender][i].balance >= amount, "Insufficent funds");
        accounts[msg.sender][i].balance -= amount;
    }

    function transfer(uint i, address receiver, uint amount) public OnlyOwner{
        require(i < accounts[msg.sender].length, "Accound id invalid");
        require(accounts[msg.sender][i].balance >= amount, "Insufficient funds");
        require(receiver != accounts[msg.sender][i].id, "Invalid account");

        withdraw(i, amount);
        accounts[receiver][i].balance += amount;

    }

    function getBalance(uint i) public view returns(uint){
        return accounts[msg.sender][i].balance;
    }

}