pragma solidity ^0.4.11;

import "../ownership/ownable.sol";
import "./Wallet.sol";

contract TimeLockedWallet is Wallet {

    uint public lockedUntil;

    function TimeLockedWallet(uint lockForDays) {
        lockedUntil = now + lockForDays * 1 days;
    }

    function withdraw(address _to, uint _amount) onlyOwner returns (bool) {
        if (now < lockedUntil) throw;

        return super.withdraw(_to, _amount);
    }
}
