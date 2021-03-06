// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Tool is ERC721, ERC721URIStorage, Pausable, Ownable {
   
    uint8 public constant MAX_TOKENS_PLUS_ONE = 6;
    uint8 public currentIndex = 1;
    bool private isOpenPublicMint = false;
    bool private isOpenALMint = false;
    bytes32 private merkleRoot;

    /** @notice claimedToken (bool) is to ensure that each address on the
    *   allowlist claims ONLY one token. This could easily be changed to an 
    *   uint to allow a fixed number of tokens for each contract.
    */
    mapping(address => bool) public claimedToken;
    
    constructor(bytes32 _root) ERC721("Tool", "TOOL") {
        merkleRoot = _root;
    }
    
    function publicMint() public  onlyWhenMintOpen {
        uint8 _currentIndex = currentIndex;
        require(_currentIndex < MAX_TOKENS_PLUS_ONE,
                "Tool: Mint would exceed max number of tokens.");
        require(msg.sender == tx.origin, "Tool: Cannot mint to contract.");
        
        _mint(msg.sender, _currentIndex);

        unchecked {
            currentIndex++;
        }

        setFullURI(_currentIndex);
    }

    function allowListMint(bytes32[] calldata _proof) 
        public  
        onlyWhenALMintOpen
        onlyValidALMintCredentials(_proof) {

            uint8 _currentIndex = currentIndex;
            require(_currentIndex < MAX_TOKENS_PLUS_ONE,
                    "Tool: Mint would exceed max number of tokens.");
            require(msg.sender == tx.origin, "Tool: Cannot mint to contract.");
            require(claimedToken[msg.sender] == false, 
                    "Tool: This wallet has already claimed their token.");
            claimedToken[msg.sender] = true;
            
            _mint(msg.sender, _currentIndex);

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

//----------------------------------ACCESS-----------------------------------\\
//---------------------------------------------------------------------------\\

    modifier onlyWhenMintOpen() {
        require(isOpenPublicMint == true, "Tool: Minting has not been opened.");
        _;
    }

    modifier onlyWhenALMintOpen() {
        require(isOpenALMint == true, "Tool: Allow list minting has not been opened.");
        _;
    }

    /** @notice The onlyValidALMintCredentials modifier is used to ensure
    *   the proof provided by the user is correct and associated w/ the address
    *   calling the allowlist mint function.
    */
    modifier onlyValidALMintCredentials(bytes32[] calldata _proof) {
        require(MerkleProof.verify(
            _proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), 
                "Tool: Invalid allowlist credentials.");
        _;
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

    /** toggleIsOpenPublicMint will change the var state that allows/does not
    *   allow the general public to mint token.
    */
    function toggleIsOpenPublicMint() public onlyOwner {
        isOpenPublicMint = !isOpenPublicMint;
    }

    /** toggleIsOpenALMint will change the var state that allows/does not
    *   allow the allowlist proof holders to mint a token.
    */
    function toggleIsOpenALMint() public onlyOwner {
        isOpenALMint = !isOpenALMint;
    }

//--------------------------------OVERRIDES----------------------------------\\
//---------------------------------------------------------------------------\\

    function tokenURI(uint256 tokenId) 
        public view override(ERC721, ERC721URIStorage) 
        returns (string memory) {
            return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId)
        internal override(ERC721, ERC721URIStorage) {
            super._burn(tokenId);

    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override {
            super._beforeTokenTransfer(from, to, tokenId);
    }
}
