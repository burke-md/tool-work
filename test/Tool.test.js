const { expect, use } = require('chai');
const { ethers } = require('hardhat');
const { MerkleTree } = require('merkletreejs');
const { keccak256 } = ethers.utils;

use(require('chai-as-promised'));

describe('Tool', function () {

    let address0Proof;
    before(async function () {
        this.Tool= await ethers.getContractFactory('Tool');
    });

    beforeEach(async function () {
        this.tool = await this.Tool.deploy();
        await this.tool.deployed();

        //Set both regular and allowlist mint to true
        await this.tool.setOpenMint(true);
        await this.tool.setOpenALMint(true);

        const accounts = await hre.ethers.getSigners();

        const allowListAccountAddresses = accounts.slice(0, 5).map(x => x.address);
        const blockListAccountAddresses = accounts.slice(5, 10).map(x => x.address);
        
        // Where each wallet address is the data to be hashed into a lead node:
        const leaves = allowListAccountAddresses.map(account => keccak256(account));
        const tree = new MerkleTree(leaves, keccak256, { sort: true});
        const merkleRoot = tree.getHexRoot();

        // After list is compiled and tree is build, each wallet holder is given
        // a key or "proof" (bytes32). These are not interchangable. 
        address0Proof = tree.getHexProof(keccak256(allowListAccountAddresses[0]));

        await this.tool.setRoot(merkleRoot);
    });

    it('increments token counter correctly', async function () {
        await this.tool.publicMint(); 
        await this.tool.publicMint();

        expect((await this.tool.getNumMintedTokens()).toString()).to.equal('2');
    });


    it('should not mint more than maximum allowable tokens', async function () {
        let isErr = false;  
        const token1 = await this.tool.publicMint();
        const token2 = await this.tool.publicMint();
        const token3 = await this.tool.publicMint();
        const token4 = await this.tool.publicMint()  
        const token5 = await this.tool.publicMint();     
    
        try {
            await this.tool.publicMint();
        } catch (err) {
            isErr = true;
        }

        expect(isErr).to.equal(true);
    });

    it('should mint a new token and append ${tokenID}.json to the base URI value.', async function () {
        const token1 = await this.tool.publicMint();
        const token2 = await this.tool.publicMint();
        const token2URI = await this.tool.tokenURI(2); 

        expect(token2URI).to.equal("ipfs://QmVCNF9M7ABGBSLkmAvamjfNs8cNdCctwr2W9Us1S6TWyF/2.json");
    });

    it('should not mint a new token after contract has been paused.', async function () {
        let isErr = false;
        await this.tool.pause();

        try { 
            await this.tool.publicMint();
        } catch (err) {
              isErr = true;
        } 

        expect(isErr).to.equal(true);
    });

    it('should mint a new token after contract has been unpaused.', async function () {
        await this.tool.pause();
        await this.tool.unpause();

        const createToken = async () => {
            await this.tool.publicMint();
        }

        expect(createToken).not.to.throw();
    });


    it('should mint a new token via allowListMint function.', async function () {
        expect(this.tool.allowListMint(address0Proof)).to.not.be.rejected;
        expect((await this.tool.getNumMintedTokens()).toString()).to.equal('1');
    });
});
