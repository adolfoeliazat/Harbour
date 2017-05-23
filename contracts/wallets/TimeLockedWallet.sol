pragma solidity ^0.4.11;

import "../ownership/ownable.sol";

contract TimeLockedWallet is ownable {

    uint public lockedUntil;

    function TimeLockedWallet(uint lockForDays) {
        lockedUntil = now + lockForDays * 1 days;
    }

    function () public payable {}

    function withdraw() onlyOwner {
        if (now < lockedUntil) throw;
        if (!msg.sender.send(this.balance)) throw;
    }
}
