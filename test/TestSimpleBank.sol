pragma solidity >=0.4.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleBank.sol";
import "../contracts/ThrowProxy.sol";
import "../contracts/CustomerOne.sol";
import "../contracts/CustomerTwo.sol";

contract TestSimpleBank {
    uint public initialBalance = 1 ether;

    SimpleBank simpleBankInstance;
    ThrowProxy proxy;
    CustomerOne customerOne;
    CustomerTwo customerTwo;
    address accountAddress;

    event LogTestEnroll(bool returnValue, bool expectedValue);
    event LogTestDeposit(uint returnBalance, uint expectedBalance);
    event LogTestWithdraw(uint returnBalance, uint expectedBalance);
    event LogTestDepositNotEnrolled(bool res);

    constructor() public payable {}

    function beforeAll() public{
       simpleBankInstance = SimpleBank(DeployedAddresses.SimpleBank());
       proxy = new ThrowProxy(address(simpleBankInstance));
        
       address(customerOne).transfer(500 wei);
       customerOne = (new CustomerOne).value(200 wei)();

       address(customerTwo).transfer(500 wei);
       customerTwo = (new CustomerTwo).value(200 wei)();
       accountAddress = address(this);
    }

    function testEnroll() public {
        bool returnValue = customerOne.enroll(simpleBankInstance);
        bool expectedValue = simpleBankInstance.enrolled(address(customerOne));
        emit LogTestEnroll(returnValue, expectedValue);
        Assert.equal(returnValue, expectedValue, "Account should be enrolled");
    }

    function testDeposit() public {
        uint depositAmount = 10 wei;
        uint returnBalance = customerOne.deposit(simpleBankInstance, depositAmount);
        uint expectedBalance = customerOne.getBalance(simpleBankInstance);
        emit LogTestDeposit(returnBalance, expectedBalance);
        Assert.equal(returnBalance, expectedBalance, "Account Balance should match after Deposit");
    }

    function testWithdraw() public {
        uint withdrawAmount = 5 wei;
        uint returnBalance = customerOne.withdraw(simpleBankInstance, withdrawAmount);
        uint expectedBalance = customerOne.getBalance(simpleBankInstance);
        emit LogTestWithdraw(returnBalance, expectedBalance);
        Assert.equal(returnBalance, expectedBalance, "Account Balance should match after withdrawl");
    }

    function testDepositWhenUserIsNotEnrolled() public {
        uint depositAmount = 5 wei;
        //customerTwo.deposit(SimpleBank(address(proxy)), depositAmount);
        //bool res = proxy.execute();
        //(bool res, ) = address(customerTwo).call(abi.encodeWithSignature("deposit(address,uint)", simpleBankInstance, depositAmount));
        SimpleBank(address(proxy)).deposit();
        bool res = proxy.execute.gas(200000)(depositAmount);
        emit LogTestDepositNotEnrolled(res);
        Assert.isFalse(res, "User is not Enrolled");
    }

    function() external {}

}