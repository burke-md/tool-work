const { MerkleTree } = require('merkletreejs');
const { keccak256 } = ethers.utils;

const generateMerkleTree = (accountInfoArr) => {
    //if(!accountInfoArr) return null;

    const allowListAccountAddresses = accountInfoArr.slice(0, 5).map(x => x.address);
    const blockListAccountAddresses = accountInfoArr.slice(5, 10).map(x => x.address);
    
    // Where each wallet address is the data to be hashed into a leaf node:
    const leaves = allowListAccountAddresses.map(account => keccak256(account));
    const tree = new MerkleTree(leaves, keccak256, { sort: true});
    const merkleRoot = tree.getHexRoot();

    // After list is compiled and tree is build, each wallet holder is given
    // a key or "proof" ( type bytes32). These are not interchangable. 
    address0Proof = tree.getHexProof(keccak256(allowListAccountAddresses[0]));
    return {
        address0Proof,
        merkleRoot
    }
};

module.exports = { generateMerkleTree };
