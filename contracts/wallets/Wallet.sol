pragma solidity ^0.4.11;

contract Wallet {

    event Deposit(address indexed _sender, uint amount);
    event Withdraw(address indexed _sender, uint amount, address _beneficiary);

    function () public payable {
        if (msg.value < 0) {
            return;
        }

        Deposit(msg.sender, msg.value);
    }
}
