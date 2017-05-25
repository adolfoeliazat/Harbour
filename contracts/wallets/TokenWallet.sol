pragma solidity ^0.4.11;

import "../ownership/ownable.sol";
import "../tokens/ERC20.sol";
import "./Wallet.sol";

contract TokenWallet is Wallet, ownable {

    function balanceOf(address _token) constant returns (uint) {
        return ERC20(_token).balanceOf(this);
    }

    function withdraw(address _to, uint _amount) onlyOwner returns (bool) {
        if (_amount < 0) {
            return false;
        }

        if (!_to.send(_amount)) {
            return false;
        }

        return true;
    }

    function withdrawToken(address _token, address _to, uint _amount) onlyOwner returns (bool) {
        if (_amount < 0) {
            return false;
        }

        return ERC20(_token).transfer(_to, _amount);
    }
}