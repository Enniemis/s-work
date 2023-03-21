// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EchoToken is ERC20 {
    constructor() ERC20("Orpheus Token", "ORPHEUS") {
        _mint(msg.sender, 100000 * (10 ** uint256(decimals())));
    }
}