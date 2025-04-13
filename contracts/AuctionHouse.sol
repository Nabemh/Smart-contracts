// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AuctionHouse{
    address public owner;
    string item;

    address[] bidders;
    uint256 endTime;
    bool isEnded;
    address private highestBidder;
    uint256 private highestBid;

    mapping (address => uint) public bid;

    constructor (address _owner, string memory _item, uint _endTime){
        owner = _owner;
        item = _item;
        endTime = block.timestamp + _endTime;
    }

    function placeBid( uint256 amount) public {
        require (endTime > block.timestamp, "Auction has already ended");
        require (amount > 0, "Can't be zero");
        require (amount > bid[msg.sender], "must be more than last bid");

        if(bid[msg.sender] == 0){
            bidders.push(msg.sender);
        }

        if(amount > highestBid){
            highestBid = amount;
            highestBidder = msg.sender;
        }
    }

    function endAuction() external {
        require(block.timestamp >= endTime, "Auction isn't going on");
        require(!isEnded, "End alreadly called");
        isEnded = true;
    }

    function getBidders() public view returns (address[] memory){
        return bidders;
    }

    function getWinner() public view returns (address, uint){
        require (isEnded, "Aunction still on going");
        return (highestBidder, highestBid);
    }
}