// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./_BasicBank.sol";

contract ExtendedBank is BasicBank {
    IERC20 token;

    constructor(address _ERC20TokenAddress) {
        token = IERC20(_ERC20TokenAddress);
    }

    modifier minAmount(uint256 _amount) {
        require(_amount > 0, "The amount can't be 0");
        _;
    }

    function depositToken(uint256 _amount) external minAmount(_amount) accountExists{
        token.transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender].tokenBalance += _amount;
    }

    function withdrawToken(uint256 _amount) external minAmount(_amount) accountExists{
        require(token.balanceOf(msg.sender) >= _amount);
        token.transferFrom(address(this), msg.sender, _amount);
        balances[msg.sender].tokenBalance -= _amount;
    }

    function checkTokenBalance() external view returns(uint256) {
        return balances[msg.sender].tokenBalance;
    }
}
