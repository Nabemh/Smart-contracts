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
        require(accounts[msg.sender][i].balance >= amount, "Insuffient funds");
        accounts[msg.sender][i].balance -= amount;
    }

    function transfer(uint i, address receiver, uint amount) public OnlyOwner{
        
    }

    function getBalance(uint i) public view returns(uint){
        return accounts[msg.sender][i].balance;
    }

}