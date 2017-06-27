pragma solidity ^0.4.11;

import "./ownership/administrable.sol";

contract Configuration is administrable {

    mapping (bytes32 => uint) values;
    mapping (bytes32 => bool) protected;

    modifier onlyPermitted(bytes32 _key) {
        if (!isOwner(msg.sender) && !isAdmin(msg.sender)) throw;
        if (isAdmin(msg.sender) && protected[_key]) throw;
        _;
    }

    function set(bytes32 _key, uint _value) onlyPermitted(_key) {
        values[_key] = _value;
    }

    function get(bytes32 _key) returns (uint) {
        return values[_key];
    }

    function protect(bytes32 _key) onlyOwner {
        protected[_key] = true;
    }

    function unprotect(bytes32 _key) onlyOwner {
        protected[_key] = false;
    }
}
