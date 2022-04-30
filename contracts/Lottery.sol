// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.4.16 <0.9.0;

contract Lottery {
    mapping(string => uint256) public age;

    constructor() {
        age["alexander"] = 27;
    }

    function getAge() public view returns (uint256) {
        return age["alexander"];
    }
}
