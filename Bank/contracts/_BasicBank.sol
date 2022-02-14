// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract BasicBank is ReentrancyGuard {

    constructor() ReentrancyGuard() {}

    mapping (address => Account) internal accounts;
    struct Account {
        bool exists;
        uint256 etherBalance;
    }

    modifier accountExists {
        require(accounts[msg.sender].exists, "Account doesn't exist");
        _;
    }

    modifier minDeposit {
        require(msg.value > 0, "You can't deposit 0 eth");
        _;
    }

    modifier balanceEmpty virtual {
        require(accounts[msg.sender].etherBalance == 0, "The balance of the account is not empty");
        _;
    }

    function openAccount() external {
        require(!accounts[msg.sender].exists, "Account already exists");
        accounts[msg.sender].exists = true;
    }

    function closeAccount() external accountExists balanceEmpty {
        accounts[msg.sender].exists = false;
    }

    function deposit() external payable accountExists minDeposit{
        accounts[msg.sender].etherBalance += msg.value;
    }

    function withdraw(uint256 _amount) external accountExists nonReentrant{
        require(accounts[msg.sender].etherBalance >= _amount, "Not enough savings");
        (bool success,) = payable(msg.sender).call{value: _amount}("");
        require(success, "Failed to withdraw ETH");
        accounts[msg.sender].etherBalance -= _amount;
    }

    function getBalance(address _of) external view returns (uint256){
        return accounts[_of].etherBalance;
    }
    function doesAccountExist(address _of) external view returns (bool){
        return accounts[_of].exists;
    }
}