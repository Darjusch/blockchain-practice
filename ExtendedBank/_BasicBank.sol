// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BasicBank {
    mapping (address => bankAccount) public balances;

    struct bankAccount  {
        uint256 ethBalance;
        uint256 tokenBalance;
        bool exists;
    }

    modifier accountExists {
        require(balances[msg.sender].exists == true, "Account doesn't exist");
        _;
    }

    modifier minDeposit {
        require(msg.value > 0, "You have to put some ETH into your account");
        _;
    }

    function openAccount() payable external minDeposit{
        require(balances[msg.sender].exists == false, "Account with that address already exists");
        balances[msg.sender].exists = true;
        balances[msg.sender].ethBalance += msg.value;
    }

    function closeAccount() external accountExists {
        require(balances[msg.sender].ethBalance == 0, "Account has to be empty");
        balances[msg.sender].exists = false;
    }

    function deposit() external payable accountExists minDeposit{
        balances[msg.sender].ethBalance += msg.value;
    }

    function withdraw(uint256 _amount) external accountExists {
        require(balances[msg.sender].ethBalance >= _amount, "Not enough savings");
        payable(msg.sender).transfer(_amount);
        balances[msg.sender].ethBalance -= _amount;
    }
}
