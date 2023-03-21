// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EchoToken is ERC20 {
    constructor() ERC20("Echo Token", "ECHO") {
        _mint(msg.sender, 10000 * (10 ** uint256(decimals())));
    }
}