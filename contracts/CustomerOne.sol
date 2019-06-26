pragma solidity >=0.4.0 <0.7.0;

import "./SimpleBank.sol";

contract CustomerOne{

    constructor() public payable{}

    function enroll(SimpleBank _simpleBankInstance) public returns (bool){
       return _simpleBankInstance.enroll();
    }

    function deposit(SimpleBank _simpleBankInstance, uint _depositAmount) public returns(uint){
        return _simpleBankInstance.deposit.value(_depositAmount)();
    }

    function withdraw(SimpleBank _simpleBankInstance, uint _withdrawAmount) public returns(uint){
        return _simpleBankInstance.withdraw(_withdrawAmount);
    }

    function getBalance(SimpleBank _simpleBankInstance) public view returns(uint){
        return _simpleBankInstance.getBalance();
    }

    function() external payable{}
}