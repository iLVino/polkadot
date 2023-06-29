// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTAuction {
    address public owner;
    uint256 public auctionId;
    mapping(uint256 => Auction) public auctions;

    struct Auction {
        address nftContract;
        uint256 tokenId;
        address payable seller;
        uint256 startPrice;
        uint256 endBlock;
        address payable highestBidder;
        uint256 highestBid;
        bool ended;
    }

    event AuctionCreated(uint256 auctionId, address indexed nftContract, uint256 indexed tokenId, address indexed seller);
    event BidPlaced(uint256 auctionId, address indexed bidder, uint256 bidAmount);
    event AuctionEnded(uint256 auctionId, address indexed winner, uint256 indexed winningBid);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        auctionId = 1;
    }

    function createAuction(
        address _nftContract,
        uint256 _tokenId,
        uint256 _startPrice,
        uint256 _endBlock
    ) external {
        require(_startPrice > 0, "Start price must be greater than zero");

        IERC721 nft = IERC721(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "Only the NFT owner can create an auction");

        nft.transferFrom(msg.sender, address(this), _tokenId);

        Auction storage newAuction = auctions[auctionId];
        newAuction.nftContract = _nftContract;
        newAuction.tokenId = _tokenId;
        newAuction.seller = payable(msg.sender);
        newAuction.startPrice = _startPrice;
        newAuction.endBlock = _endBlock;

        emit AuctionCreated(auctionId, _nftContract, _tokenId, msg.sender);

        auctionId++;
    }

    function placeBid(uint256 _auctionId) external payable {
        Auction storage auction = auctions[_auctionId];
        require(!auction.ended, "The auction has ended");
        require(block.number <= auction.endBlock, "The auction has already ended");

        require(msg.value > auction.highestBid, "Bid amount must be higher than the current highest bid");

        if (auction.highestBidder != address(0)) {
            auction.highestBidder.transfer(auction.highestBid);
        }

        auction.highestBidder = payable(msg.sender);
        auction.highestBid = msg.value;

        emit BidPlaced(_auctionId, msg.sender, msg.value);
    }

    function endAuction(uint256 _auctionId) external {
        Auction storage auction = auctions[_auctionId];
        require(!auction.ended, "The auction has already ended");
        require(block.number > auction.endBlock, "The auction has not ended yet");

        auction.ended = true;

        IERC721 nft = IERC721(auction.nftContract);
        nft.transferFrom(address(this), auction.highestBidder, auction.tokenId);

        emit AuctionEnded(_auctionId, auction.highestBidder, auction.highestBid);
    }

    function getAuctionDetails(uint256 _auctionId)
        external
        view
        returns (
            address,
            uint256,
            address,
            uint256,
            uint256,
            address,
            uint256,
            bool
        )
    {
        Auction storage auction = auctions[_auctionId];
        return (
            auction.nftContract,
            auction.tokenId,
            auction.seller,
            auction.startPrice,
            auction.endBlock,
            auction.highestBidder,
            auction.highestBid,
            auction.ended
        );
    }
}
