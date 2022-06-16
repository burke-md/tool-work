# Tool work

This repo will be a continuation of the work that began in previous project. 
It can be found [here](https://github.com/burke-md/tool-nft).

The goals of this are:

- [x] Use CI to run tests and gas efficiency report when code is pushed
- [ ] Rework whitelist/allow list implementation (use Merkle tree)
- [x] Examine current gas efficiency (gas efficiency to run on merge w/ CI)
- [ ] Make any changes possible to improve gas efficiency 
See documentation/gasEfficiency.md for break down of changes and their effect.

## Reports 
***

```npx hardhat test``` Will show tests and gas efficiency in the terminal

```npx hardhat coverage``` Will show test and test coverage in the terminal
