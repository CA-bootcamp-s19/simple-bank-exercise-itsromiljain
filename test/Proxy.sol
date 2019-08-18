pragma solidity >=0.4.0 <0.7.0;

import "../contracts/SimpleBank.sol";

contract Proxy{

    SimpleBank public _simpleBank;
    
    constructor(SimpleBank simpleBank) public { _simpleBank = simpleBank; }

    function enroll() public {
        _simpleBank.enroll();
    }

    function deposit(uint _depositAmount) public returns(bool){
        (bool success,) = address(_simpleBank).call.value(_depositAmount)(abi.encodeWithSignature("deposit()"));
        return success;
    }

    function withdraw(uint _withdrawAmount) public returns(bool){
        (bool success,) =  address(_simpleBank).call(abi.encodeWithSignature("withdraw(uint)", _withdrawAmount));
        return success;
    }

    function getBalance() public view returns(uint){
        return _simpleBank.getBalance();
    }

    function() external payable{}
}