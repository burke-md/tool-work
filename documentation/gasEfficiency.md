# Gas

Here the changes made to improve the Tool contract from a gas efficiency 
perspective will be noted.


### Converting the token Id into a string for the URI:

Previously a lib was being imported from OZ (Strings). The has been removed and
a small function ```uint2str``` has been written. Running the gas analyzer shows 
that an average of 335 gas will now be saved. At a current gas price of 38.72 
Gwei that is 12 971.2 Gwei.

### Tracking the number of minted NFTs:

Previously the contract used the 'Counters' util form OZ. Moving away from that
lib and towards a more simplistic uint8 value to increment and a constant 
```MAX_ID_PLUS_ONE``` (using the max value plus one enables the contract to 
avoid the more expensive <= operator and instead use the <). Additionally the 
minting process refers to the current minted value multiple times. This gets 
held in the function to avoid reading from the stored value multiple times.
Using the gas price of 38.72 the savings of these changes amount to
287 418.56 Gwei.

### Using ```unchecked``` block where over/under flow is impossible:

In the newer release of solidity, safeMath is no longer required to prevent 
under/over flow conditions. However, this included protection of course costs 
gas. Within a protected block of code (where require statments prevent such 
conditions) we can escape this included feature. See within the mint function
for incrementing token id/index. The savings are 4026.88 Gwei.

### Remove use of ```_safeMint```:

_safeMint adds an extra protection (when compared to _mint) for the purposes of 
ensuring the transfer is processed properly when minting to a contract (as 
opposed to a wallet). As this contract intends to mint dirrectly to users and not
other contracts (a check has been made for this), the use of _safeMint is not 
required. Any failed transactions will still revert as usual. This change has 
saved 110 506.88 Gwei.

### Compiler optimizer:

Up until this time all optimizations have been to the minting function. This 
optimization however, effects the contract as a whole. The minting function it
self has saved 75 813.76 Gwei, however considerable savings across the entire 
contract can be seen.
