// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CrowdFunding is ReentrancyGuard {
    
    struct Campaign {
        address owner;
        string title;
        string email;
        string description;
        string category;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;

    modifier onlyOwner(uint256 _id) {
        require(msg.sender == campaigns[_id].owner, "Only owner can make changes");
        _;
    }

    event newAction(
        address indexed creator,
        string action,
        uint256 timestamp
    );

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _email,
        string memory _description,
        string memory _category,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        require(_deadline > block.timestamp, "Deadline should be a later date");

        Campaign storage campaign = campaigns[numberOfCampaigns];
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.email = _email;
        campaign.description = _description;
        campaign.category = _category;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected  = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        emit newAction(_owner, "New Campaign!", block.timestamp);

        return numberOfCampaigns - 1;
    }

    function donate(uint256 _id) public payable nonReentrant {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp < campaign.deadline, "Campaign has ended");

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        require(sent, "Donation failed to send");

        campaign.amountCollected += amount;

        emit newAction(msg.sender, "Donation", block.timestamp);
    }

    function withdrawToTeam(address _owner, uint256 _id) public nonReentrant {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp > campaign.deadline, "Campaign still in progress");
        require(msg.sender == campaign.owner, "Only the campaign owner can withdraw");
        require(_owner != address(0), "Enter valid address");

        uint256 amount = campaign.amountCollected;
        campaign.amountCollected = 0;

        (bool success, ) = payable(_owner).call{value: amount}("");
        require(success, "Failed to send Ether");

        emit newAction(_owner, "Withdrawal", block.timestamp);
    }

    function getDonators(uint256 _id) public view returns (address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getByCategory(uint256 _id) public view returns (string memory){
        return campaigns[_id].category;
    }

    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint i = 0; i < numberOfCampaigns; i++) {
            allCampaigns[i] = campaigns[i];
        }
        return allCampaigns;
    }

    // Accept plain ETH transfers
    receive() external payable {
        emit newAction(msg.sender, "Direct ETH received (receive)", block.timestamp);
    }

    // Catch wrong function calls or ETH with data
    fallback() external payable {
        emit newAction(msg.sender, "Direct ETH received (fallback)", block.timestamp);
    }
}
