const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Tool', function () {
    let accounts;
    before(async function () {
        this.Tool= await ethers.getContractFactory('Tool');
    });

    beforeEach(async function () {
        this.tool = await this.Tool.deploy();
        await this.tool.deployed();

        //Set both regular and allowlist mint to true
        await this.tool.setOpenMint(true);
        await this.tool.setOpenALMint(true);
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


    xit('should mint a new token via allowListMint function.', async function () {
        console.log(`accounts: ${accounts}`);
        let isErr = false; 

        try {
            await this.tool.allowListMint();
        } catch (err) {
            isErr = true
        }

        expect(isErr).to.equal(false);
        expect((await this.tool.getNumMintedTokens()).toString()).to.equal('1');
    });
});
