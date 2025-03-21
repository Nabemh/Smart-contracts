// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

contract Profile {
    struct CustomerProfile {
        address userAddress; 
        string username; 
        uint balance;
        uint creationTimestamp;
    }
    
    mapping(address => CustomerProfile) public profiles;

    function setProfile(address _userAddress, string memory _username) public {
    
        profiles[msg.sender] = CustomerProfile(_userAddress, _username, 0, block.timestamp);

    }

    function getProfile(address _user) public view returns (CustomerProfile memory) {
        return profiles[_user];
    }
}