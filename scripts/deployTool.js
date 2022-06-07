const { ethers } = require("hardhat");

async function main () {
  const Tool = await ethers.getContractFactory('Tool');
  console.log('Deploying Tool..');
  const tool = await Tool.deploy();
  await tool.deployed();
  console.log(`Tool deployed to: ${tool.address}`);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  });