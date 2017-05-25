pragma solidity ^0.4.11;

import "../ownership/ownable.sol";
import "./Wallet.sol";

contract TimeLockedWallet is Wallet, ownable {

    uint public lockedUntil;

    function TimeLockedWallet(uint lockForDays) {
        lockedUntil = now + lockForDays * 1 days;
    }

    function withdraw() onlyOwner {
        if (now < lockedUntil) throw;

        uint _amount = this.balance;
        if (!msg.sender.send(_amount)) throw;
                
        Withdraw(msg.sender, _amount, msg.sender);
    }
}
