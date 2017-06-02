pragma solidity ^0.4.11;

import "../ownership/ownable.sol";

contract Wallet is ownable {

    event Deposit(address indexed _sender, uint amount);
    event Withdraw(address indexed _sender, uint amount, address _beneficiary);

    function () public payable {
        if (msg.value < 0) {
            return;
        }

        Deposit(msg.sender, msg.value);
    }
    
    function withdraw(address _to, uint _amount) onlyOwner returns (bool) {
        if (_amount < 0) {
            return false;
        }

        if (!_to.send(_amount)) {
            return false;
        }

        Withdraw(msg.sender, _amount, _to);
        return true;
    }
}
