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

    

}