// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Target {
    uint256 amount;

    function amazing(uint256 _amount) external payable returns (bool success, bytes memory data){
        amount = _amount;
        return (true, "s");
    }

}