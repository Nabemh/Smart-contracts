// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transactions{

    struct Account{
        uint balance;
        uint timestamp;
        address sender;
    }

    mapping (address => Account[]) public accounts;

}