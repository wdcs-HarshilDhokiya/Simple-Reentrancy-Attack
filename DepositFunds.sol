// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Source:https://hackernoon.com/hack-solidity-reentrancy-attack

contract DepositFunds {
    mapping(address => uint) public balances;
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;  //This statement will be execute after whole function(where this modifier is used) Execute
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public noReentrant{
        uint bal = balances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}