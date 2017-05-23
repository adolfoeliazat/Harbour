pragma solidity ^0.4.11;

import "../ownership/ownable.sol";
import "../tokens/ERC20.sol";

contract TokenWallet is ownable {

    function () public payable {}

    function balanceOf(address _token) constant returns (uint) {
        return ERC20(_token).balanceOf(this);
    }

    function transfer(address _token, address _to, uint _amount) return (bool) {
        return ERC20(_token).transfer(_to, _amount);
    }
}