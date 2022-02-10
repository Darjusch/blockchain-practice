// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//Make an ETH bank Contract 
contract ETHBank {
    mapping (address => bankAccount) public balances;

    struct bankAccount  {
        uint256 balance;
        bool exists;
    }

    //Function where users can open an account (only if they dont have one already)
    function openAccount() external {
        require(balances[msg.sender].exists == false, "Account with that address already exists");
        balances[msg.sender].exists = true;
    }

    //Function close the account (only if its empty)
    function closeAccount() external {
        require(balances[msg.sender].exists == true, "Account doesn't exist");
        require(balances[msg.sender].balance == 0, "Account has to be empty");
        balances[msg.sender].exists = false;
    }

    //Function to deposit ETH into the account
    function deposit() external payable {
        require(msg.value > 0, "You have to put some ETH into your account");
        balances[msg.sender].balance += msg.value;
    }

    //Function to withdraw from their account.
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender].balance >= _amount, "Not enough savings");
        payable(msg.sender).transfer(_amount);
        balances[msg.sender].balance -= _amount;
    }
}
