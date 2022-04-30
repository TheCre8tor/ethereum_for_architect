// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract Coin {
    /* The address type is a 160-bit value that 
       does not allow any arithmetic operations.*/
    address public minter;

    /* mapping is equivalent to javascript object
       { 0x5fbdb2315678afecb367f032d93f642f64180aa3: 100000 } 
       */
    mapping(address => uint256) public balances;
    mapping(string => string) public names;

    /* Events allow clients to react to specific
       contract changes you declare */
    event Sent(address from, address to, uint256 amount);

    /* Contructor code is only run when the contract
       is created */
    constructor() {
        // Permanently store the address.
        minter = msg.sender;

        // Testing mapping only.
        balances[msg.sender] += 100000;
        names["name"] = "Alexander";
    }

    function mint(address receiver, uint256 amount) public {
        // ensures that only the creator of the contract can call mint.
        require(msg.sender == minter);

        balances[receiver] += amount;
    }

    /* Errors allow you to provide information about
       why an operation failed. They are returned
       to the caller of the function 
       
       Errors are used together with the [revert] statement.*/
    error InsufficientBalance(uint256 requested, uint256 available);

    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getName() public view returns (string memory) {
        return names["name"];
    }
}
