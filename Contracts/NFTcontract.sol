// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTContract is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("BatchThings", "BTH") {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}


0xd204c45e0000000000000000000000003d875eb57275a2df3dfd187fe0e9ff7ae87b0bc3000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000057777773130000000000000000000000000000000000000000000000000000000
0xd204c45e00000000000000000000000037f06a17d180318fcbbee8dcbadaa866b1f3bc2b000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000057777773131000000000000000000000000000000000000000000000000000000
0xd204c45e000000000000000000000000cb2ed59c9427a43f72e2d31e1a51b33209aaec96000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000057777773132000000000000000000000000000000000000000000000000000000

0x3d875Eb57275a2Df3DfD187fe0e9fF7Ae87b0BC3
0x37F06A17D180318FCBbEE8dCbADaa866b1F3bc2b
0xCb2ED59c9427a43f72e2D31e1a51b33209AaEc96