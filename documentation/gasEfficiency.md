# Gas

Here the changes made to improve the Tool contract from a gas efficiency 
perspective will be noted.


### Converting the token Id into a string for the URI:

Previously a lib was being imported from OZ (Strings). The has been removed and
a small function ```uint2str``` has been written. Running the gas analyzer shows 
that an average of 335 gas will now be saved. At a current gas price of 38.72 
Gwei that is 12 971.2 Gwei.
