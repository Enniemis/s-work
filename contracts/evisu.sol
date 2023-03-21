// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EvisuPool {
    IERC20 public eToken;
    IERC20 public eCoinToken;
    mapping(address => uint) public echoBalances;
    mapping(address => uint) public orpheusBalances;
    uint public totalEcho;
    uint public totalOrpheus;
    uint public totalShares;
    mapping(address => uint) public shares;

    constructor(address _eToken, address _eCoinToken) {
        eToken = IERC20(_eToken);
        eCoinToken = IERC20(_eCoinToken);
    }

    function addEvisu(uint echoAmount, uint orpheusAmount) external {
        require(echoAmount > 0 && orpheusAmount > 0, "Invalid Evisu amount");
        eToken.transferFrom(msg.sender, address(this), echoAmount);
        eCoinToken.transferFrom(msg.sender, address(this), orpheusAmount);
        echoBalances[msg.sender] += echoAmount;
        orpheusBalances[msg.sender] += orpheusAmount;
        totalEcho += echoAmount;
        totalOrpheus += orpheusAmount;
        uint share = 0;
        if (totalShares == 0) {
            share = sqrt(echoAmount * orpheusAmount);
        } else {
            share = (sqrt(echoAmount * orpheusAmount) * totalShares) / sqrt(totalEcho * totalOrpheus);
        }
        shares[msg.sender] += share;
        totalShares += share;
    }

    function removeEvisu(uint share) external {
        require(share > 0 && shares[msg.sender] >= share, "Invalid share amount");
        uint echoAmount = (share * totalEcho) / totalShares;
        uint orpheusAmount = (share * totalOrpheus) / totalShares;
        echoBalances[msg.sender] -= echoAmount;
        orpheusBalances[msg.sender] -= orpheusAmount;
        totalEcho -= echoAmount;
        totalOrpheus -= orpheusAmount;
        shares[msg.sender] -= share;
        totalShares -= share;
        eToken.transfer(msg.sender, echoAmount);
        eCoinToken.transfer(msg.sender, orpheusAmount);
    }

    function getReward() external {
        uint echoBalance = eToken.balanceOf(address(this));
        uint orpheusBalance = eCoinToken.balanceOf(address(this));
        uint echoReward = (echoBalance * totalShares) / totalEcho;
        uint orpheusReward = (orpheusBalance * totalShares) / totalOrpheus;
        for (uint256 account = 0; account < totalShares; account++) {
            address accountAddress = address(uint160(account));
            uint share = shares[accountAddress];
            uint echoAmount = (share * echoReward) / totalShares;
            uint orpheusAmount = (share * orpheusReward) / totalShares;
            eToken.transfer(accountAddress, echoAmount);
            eCoinToken.transfer(accountAddress, orpheusAmount);
        }
    }

    function sqrt(uint x) internal pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
