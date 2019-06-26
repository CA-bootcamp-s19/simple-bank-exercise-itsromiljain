pragma solidity >=0.4.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleBank.sol";
import "../contracts/ThrowProxy.sol";
import "../contracts/CustomerOne.sol";

contract TestSimpleBank {

    SimpleBank simpleBankInstance;
    ThrowProxy proxy;
    CustomerOne customerOne;

    uint public initialBalance = 1 ether;

    function beforeAll() public{
       simpleBankInstance = SimpleBank(DeployedAddresses.SimpleBank());
       proxy = new ThrowProxy(address(simpleBankInstance));

       address(customerOne).transfer(500 wei);
       customerOne = (new CustomerOne).value(200 wei)();
    }

    function testEnroll() public {
        bool returnValue = customerOne.enroll(simpleBankInstance);
        bool expectedValue = simpleBankInstance.enrolled(address(customerOne));
        Assert.equal(returnValue, expectedValue, "Account should be enrolled");
    }

    function testDeposit() public {
        uint depositAmount = 10 wei;
        uint returnBalance = customerOne.deposit(simpleBankInstance, depositAmount);
        uint expectedBalance = customerOne.getBalance(simpleBankInstance);
        Assert.equal(returnBalance, expectedBalance, "Account Balance should match after Deposit");
    }

    function testWithdraw() public {
        uint withdrawAmount = 5 wei;
        uint returnBalance = customerOne.withdraw(simpleBankInstance, withdrawAmount);
        uint expectedBalance = customerOne.getBalance(simpleBankInstance);
         Assert.equal(returnBalance, expectedBalance, "Account Balance should match after withdrawl");
    }

    function testDepositWhenUserIsNotEnrolled() public {
        uint depositAmount = 5 wei;
        address(proxy).transfer(500 wei);
        SimpleBank(address(proxy)).deposit.value(depositAmount)();
        bool res = proxy.execute.gas(20000)();
        Assert.isFalse(res, "User is not Enrolled");
    }

}