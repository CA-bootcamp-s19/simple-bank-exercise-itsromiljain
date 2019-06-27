pragma solidity >=0.4.0 <0.7.0;

import "./SimpleBank.sol";

contract CustomerTwo {

    constructor() public payable{}

    function deposit(SimpleBank _simpleBankInstance, uint _depositAmount) public returns(uint){
        return _simpleBankInstance.deposit.value(_depositAmount)();
    }

    function() external payable{}
}