// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ReadEstate {
    struct Listing {
        address owner;
        string title;
        string location;
        string propertyType;
        string description;
        uint256 entryPrice;
        uint256 deadline;
        string image;
        address[] bidders;
        uint256[] bids;
    }

    mapping(uint256 => Listing) public listings;

    uint256 public numberOfListings = 0;

    modifier onlyOwner(address) {
       // require(owner = msg.sender, "Only owner can make changes!");
        _;
    }

    function createListing(address _owner, string memory _title, string memory _location, string memory _propertyType,
    string memory _description, uint256 _entryPrice, uint256 _deadline, string memory _image) public returns (uint256) {
        Listing storage listing = listings[numberOfListings];

        require(listing.deadline < block.timestamp, "Deadline should be a later date!");

        listing.owner = _owner;
        listing.title = _title;
        listing.location = _location;
        listing.propertyType = _propertyType;
        listing.description = _description;
        listing.entryPrice = _entryPrice;
        listing.deadline = block.timestamp + _deadline;
        listing.image = _image;

        numberOfListings++;
        return numberOfListings - 1;
    }

    function removeListing() public{
        // require that the listing is actually a listing
        // require the person that actaully created the listing
        // require only owner

    }

    function placeBid(uint256 amount) public {
        // require that amount is greater than the entry price
        // require that the listing is actually a listing
        // require the amount is greater than 0
        // require that it's before the deadline
        // require each new bid is bigger than the last
    }

    function reverseBid(uint _id) public {
        // require that the listing is actually a listing
        // require the person that placed the bid
    }

    function getWinners() public {
        // require this happens only after we have completed the campaign
    }

    function bidEnd()public{
        //pay winner if there is one
        //reverse money to others
    }

    function getBids(uint256 _id) public view returns (address[] memory, uint256[] memory){
    }

    function getListings() public view returns (Listing[] memory){
    }
}