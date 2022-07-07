const { expect, use } = require('chai');
const { ethers } = require('hardhat');
const { generateMerkleTree } = require('./utils/merkleTree');

use(require('chai-as-promised'));

describe('Tool', function () {
    before(async function () {
        this.Tool= await ethers.getContractFactory('Tool');
    });

    beforeEach(async function () {
        const availableAccounts = await hre.ethers.getSigners();
        const { 
            address0Proof, 
            address1Proof,
            merkleRoot } = generateMerkleTree(availableAccounts);

        this.tool = await this.Tool.deploy(merkleRoot);
        await this.tool.deployed();

        //Set both regular and allowlist mint to true
        await this.tool.toggleIsOpenPublicMint();
        await this.tool.toggleIsOpenALMint();
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

    it('should mint a new token via allowListMint function.', async function () {
        expect(this.tool.allowListMint(address0Proof)).to.not.be.rejected;
        expect((await this.tool.getNumMintedTokens()).toString()).to.equal('1');
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

    xit('should toggle allowlist minting on/off correctly.', async function () {
        //expect(this.tool.allowListMint(address0Proof)).to.not.be.rejected;

        await this.tool.toggleIsOpenALMint();

        //expect(await this.tool.allowListMint(address0Proof)).to.be.rejected;
    });

    xit('should toggle public`  minting on/off correctly.', async () => {
        expect(true).to.equal(true);
    });
});
