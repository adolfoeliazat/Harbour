pragma solidity ^0.4.11;

contract ownable {

    address public owner;

    modifier onlyOwner {
        if (!isOwner(msg.sender)) throw;
        _;
    }

    function ownable() {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) onlyOwner {
        owner = _newOwner;
    }

    function isOwner(address _address) returns (bool) {
        return owner == _address;
    }
}
