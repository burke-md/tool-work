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
