// SPDX-License-Identifier: Unlicense
pragma solidity >=0.4.16 <0.9.0;

/* A contract in the sense of Solidity is a collection of code 
   (its functions) and data (its state) that resides at a specific 
   address on the Ethereum blockchain. */

contract SimpleStorage {
    /* The line uint storedData; declares a state variable called 
       storedData of type uint (unsigned integer of 256 bits). 
    
       You can think of it as a single slot in a database that you can 
       query and alter by calling functions of the code that manages the 
       database. 
     */
    uint256 storeData; // This is called a state variable.

    function set(uint256 value) public {
        storeData = value;
    }

    function get() public view returns (uint256) {
        return storeData;
    }
}
