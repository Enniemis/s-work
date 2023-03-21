pragma solidity ^0.8.17;

contract Evisu {
    string public name = "Evisu";
    string public symbol = "MTK";
    uint8 public decimals = 18; // 设置代币精度为 18

    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    constructor() {
        _totalSupply = 1000000 * 10 ** decimals; // 将代币总量设置为 1,000,000 个
        _balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(amount <= _balances[msg.sender], "Insufficient balance.");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
}
