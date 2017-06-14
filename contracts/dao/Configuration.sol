pragma solidity ^0.4.11;

import "../ownership/administrable.sol";

contract Configuration is administrable {

    mapping (string => uint) values;
    mapping (string => bool) protected;

    modifier onlyPermitted(string _key) {
        if (!isOwner(msg.sender) && !isAdmin(msg.sender)) throw;
        if (isAdmin(msg.sender) && protected[_key]) throw;
        _;
    }

    function set(string _key, uint _value) onlyPermitted(_key) {
        values[_key] = _value;
    }

    function get(string _key) returns (uint) {
        return values[_key];
    }

    function protect(string _key) onlyOwner {
        protected[_key] = true;
    }

    function unprotect(string _key) onlyOwner {
        protected[_key] = false;
    }
}
