pragma solidity ^0.4.11;

contract ownable {

    address public owner;

    modifier onlyOwner {
        if (owner != msg.sender) throw;
        _;
    }

    function Ownable() {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) onlyOwner {
        owner = _newOwner;
    }
}
