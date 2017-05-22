pragma solidity ^0.4.11;

contract ownable {

    address owner;

    modifier onlyOwner {
        if (owner != msg.sender) throw;
        _;
    }

    function ownable() {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) onlyOwner {
        owner = _newOwner;
    }
}
