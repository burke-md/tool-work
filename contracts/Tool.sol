// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Tool is ERC721, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
    
    constructor() ERC721("Tool", "TOOL") {}

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmVCNF9M7ABGBSLkmAvamjfNs8cNdCctwr2W9Us1S6TWyF/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner {
        require(_tokenIdCounter.current() < 5, 'tokenIdCounter has incremented beyond maximum number of tokens');

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        setFullURI(tokenId);
    }

    function setFullURI(uint256 tokenId) internal {
        string memory suffix = string(
            abi.encodePacked(
                uint2str(tokenId), 
                ".json"));

        _setTokenURI(tokenId, suffix);
    }


//----------------------------------HELPER-----------------------------------\\
//---------------------------------------------------------------------------\\

    function uint2str(uint _int) internal pure returns (string memory) {
        if (_int == 0) {
            return "0";
        }
        uint j = _int;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_int != 0) {
            unchecked { bstr[k--] = bytes1(uint8(48 + _int % 10)); }
            _int /= 10;
        }
        return string(bstr);
    }

//---------------------------------GETTERS-----------------------------------\\
//---------------------------------------------------------------------------\\

    function getNumMintedTokens() public view returns(uint256) {
        return _tokenIdCounter.current();
    }

//--------------------------------OVERRIDES----------------------------------\\
//---------------------------------------------------------------------------\\

    function _burn(uint256 tokenId) 
        internal override(ERC721,
        ERC721URIStorage) {
            super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) 
        public view override(ERC721, ERC721URIStorage) 
        returns (string memory) {
            return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override {
            super._beforeTokenTransfer(from, to, tokenId);
    }
}
