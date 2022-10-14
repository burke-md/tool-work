# Tool work 

This repo will be a continuation of the work that began in previous project. 
It can be found [here](https://github.com/burke-md/tool-nft).

The goals of this are:

- [x] Use CI to run tests and gas efficiency report when code is pushed
- [x] Rework whitelist/allow list implementation (use Merkle tree)
- [x] Write appropriate tests for allowlist
- [x] Examine current gas efficiency (gas efficiency to run on merge w/ CI)
- [x] Make any changes possible to improve gas efficiency 

See ```documentation/gasEfficiency.md``` for break down of changes and their effect. Many changes have been made, however, this will be an ongoing effort.

## Reports 

```npx hardhat test``` Will show tests and gas efficiency in the terminal

```npx hardhat coverage``` Will show test and test coverage in the terminal

![Screen Shot 2022-06-24 at 9 50 07 PM](https://user-images.githubusercontent.com/22263098/175753825-cc394d25-0e36-44e3-a801-ddec478a76f0.png)

## Next steps

- [ ] Contiunue to explore gas efficiency(perhaps an alternative ERC standard)
- [ ] Dive into possible security issues/analysis tools
