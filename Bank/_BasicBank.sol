// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BasicBank {
    mapping (address => uint256) public totalAmount;
    mapping (address => uint256) public etherBalance;


    modifier accountExists {
        require(totalAmount[msg.sender] > 0, "Account doesn't exist");
        _;
    }

    modifier minDeposit {
        require(msg.value > 0, "You have to put some ETH into your account");
        _;
    }

    modifier balanceNotZero {
        require(totalAmount[msg.sender] == 0, "The balance of the account is not empty");
        _;
    }

    function openAccount() external payable minDeposit balanceNotZero{
        etherBalance[msg.sender] += msg.value;
        totalAmount[msg.sender] += msg.value;
    }

    function deposit() external payable accountExists minDeposit{
        etherBalance[msg.sender] += msg.value;
        totalAmount[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external accountExists {
        require(etherBalance[msg.sender] >= _amount, "Not enough savings");
        payable(msg.sender).transfer(_amount);
        etherBalance[msg.sender] -= _amount;
        totalAmount[msg.sender] -= _amount;
    }
}