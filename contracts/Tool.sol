// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";


contract Tool is ERC721, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
    
    constructor() ERC721("Tool", "TOOL") {}
    
    uint8 public constant MAX_TOKENS_PLUS_ONE = 6;
    uint8 public currentIndex = 1;
    bytes32 private merkleRoot;
    bool private openMint = false;
    bool private openALMint = false;

    modifier onlyWhenMintOpen () {
        require(openMint == true, "Tool: Minting has not been opened.");
        _;
    }

    modifier onlyWhenALMintOpen () {
        require(openALMint == true, "Tool: Allow list minting has not been opened.");
        _;
    }

    function publicMint(address _to) public  onlyWhenMintOpen {
        uint8 _currentIndex = currentIndex;
        require(_currentIndex < MAX_TOKENS_PLUS_ONE,
                'tokenIdCounter has incremented beyond maximum number of tokens');
        
        require(msg.sender == tx.origin, "Tool: Cannot mint to contract.");
        
        _mint(_to, _currentIndex);

        unchecked {
            currentIndex++;
        }

        setFullURI(_currentIndex);
    }

    function allowListMint(address _to) public  onlyWhenALMintOpen {
        uint8 _currentIndex = currentIndex;
        require(_currentIndex < MAX_TOKENS_PLUS_ONE,
                'tokenIdCounter has incremented beyond maximum number of tokens');
        
        require(msg.sender == tx.origin, "Tool: Cannot mint to contract.");
        
        _mint(_to, _currentIndex);

        unchecked {
            currentIndex++;
        }

        setFullURI(_currentIndex);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
//----------------------------------HELPER-----------------------------------\\
//---------------------------------------------------------------------------\\

    /** @notice The uint2str function is a helper for handling the 
    *   concatenation of string numbers.
    */
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

    /** @notice The _baseURI function is a helper, called on mint to point
    *   to the NFT meta data.
    */
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmVCNF9M7ABGBSLkmAvamjfNs8cNdCctwr2W9Us1S6TWyF/";
    }

    /** @notice The setFullURI function is a helper called by the minting 
    *   function to ensure the URI correctly points to the IPFS meta data.
    */
    function setFullURI(uint256 tokenId) internal {
        string memory suffix = string(
            abi.encodePacked(
                uint2str(tokenId), 
                ".json"));

        _setTokenURI(tokenId, suffix);
    }

//---------------------------------GETTERS-----------------------------------\\
//---------------------------------------------------------------------------\\

    function getNumMintedTokens() public view returns(uint256) {
        return currentIndex - 1;
    }
//---------------------------------SETTERS-----------------------------------\\ 
//---------------------------------------------------------------------------\\

    function setRoot(bytes32 _root) public onlyOwner {
        merkleRoot = _root;
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
