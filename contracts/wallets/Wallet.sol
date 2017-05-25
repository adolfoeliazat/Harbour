pragma solidity ^0.4.11;

contract Wallet {

    event Deposit(address indexed sender, uint value);

    function () public payable {
        if (msg.value < 0) {
            return;
        }

        Deposit(msg.sender, msg.value);
    }
}
