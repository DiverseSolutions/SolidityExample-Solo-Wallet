// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract SoloWallet {
    uint public _balance;
    address payable private owner;

    event depositFired(uint amount);
    event withdrawFired(uint amount);
    event fallbackFired(uint amount);

    modifier onlyOwner(){
        require(owner == msg.sender,"Not Contract Owner");
        _;
    }

    constructor(address _owner){
        owner = payable(_owner);
    }

    fallback() external payable {
        _balance += msg.value;
        emit fallbackFired(msg.value);
    }

    receive() external payable {
        _balance += msg.value;
        emit fallbackFired(msg.value);
    }

    function deposit() public payable {
        _balance += msg.value;
        emit depositFired(msg.value);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: _balance }("");
        require(success,"Failed To Withdraw");
        emit withdrawFired(_balance);

        _balance = 0;
    }
}