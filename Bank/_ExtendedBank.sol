// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./_BasicBank.sol";

contract ExtendedBank is BasicBank{
    mapping (address => mapping(address => uint256)) public balances;

    modifier minAmount(uint256 _amount) {
        require(_amount > 0, "The amount can't be 0");
        _;
    }

    function depositToken(address _token, uint256 _amount) external minAmount(_amount) accountExists{
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender][_token] += _amount;
        totalAmount[msg.sender] += _amount;
    }

    function withdrawToken(address _token, uint256 _amount) external minAmount(_amount) accountExists{
        require(balances[msg.sender][_token] >= _amount);
        IERC20(_token).transfer(msg.sender, _amount);
        balances[msg.sender][_token] -= _amount;
        totalAmount[msg.sender] -= _amount;
    }

    function checkTokenBalance(address _token) external view returns(uint256) {
        return balances[msg.sender][_token];
    }
}
