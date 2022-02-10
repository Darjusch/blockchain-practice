// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ExtendedBank {
    mapping (address => bankAccount) public balances;
    IERC20 token;

    constructor(address _ERC20TokenAddress) {
        token = IERC20(_ERC20TokenAddress);
    }

    struct bankAccount  {
        uint256 balance;
        bool exists;
    }

    modifier accountExists {
        require(balances[msg.sender].exists == true, "Account doesn't exist");
        _;
    }

    modifier minDeposit {
        require(msg.value > 0, "You have to deposit more ETH");
        _;
    }

    modifier minAmount(uint256 _amount) {
        require(_amount > 0, "The amount can't be 0");
        _;
    }
    function getAllowance(address owner, address spender) view external returns(uint256){
        return token.allowance(owner, spender);
    }

    // Maybe new contract TokenBank and let ExtendedBank inherit?
    function depositToken(uint256 _amount) external minAmount(_amount) accountExists{
        token.approve(address(this), _amount);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdrawToken(uint256 _amount) external minAmount(_amount) accountExists{
        require(token.balanceOf(msg.sender) >= _amount);
        token.approve(msg.sender, _amount);
        token.transferFrom(address(this), msg.sender, _amount);
    }

    function checkTokenBalance() external view returns(uint256) {
        return token.balanceOf(msg.sender);
    }

    function checkBalance() external view returns(uint256) {
        return balances[msg.sender].balance;
    }

    function openAccount() payable external minDeposit{
        require(balances[msg.sender].exists == false, "Account with that address already exists");
        balances[msg.sender].exists = true;
        balances[msg.sender].balance += msg.value;
    }

    function closeAccount() external accountExists {
        require(balances[msg.sender].balance == 0, "Account has to be empty");
        require(token.balanceOf(msg.sender) == 0);
        balances[msg.sender].exists = false;
    }

    function deposit() external payable accountExists minDeposit{
        balances[msg.sender].balance += msg.value;
    }

    function withdraw(uint256 _amount) external accountExists minAmount(_amount){
        require(balances[msg.sender].balance >= _amount, "Not enough savings");
        payable(msg.sender).transfer(_amount);
        balances[msg.sender].balance -= _amount;
    }    
}
