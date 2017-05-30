pragma solidity ^0.4.11;

import "../ownership/ownable.sol";

contract Token is ownable {

    string public name;
    string public symbol;

    uint public decimals = 18;
    uint public totalSupply;

    bool public mintFinished = false;

    mapping (address => mapping (address => uint)) allowed;
    mapping (address => uint) balances;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Mint(address indexed to, uint value);
    event MintFinished();

    modifier canMint {
        if (mintFinished) throw;
        _;
    }

    function Token(string _name, string _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function totalSupply() constant returns (uint) {
        return totalSupply;
    }

    function transfer(address _to, uint _value) returns (bool) {
        if (balances[msg.sender] < _value || _value <= 0) {
            return false;
        }

        transferFunds(msg.sender, _to, _value);
        Transfer(msg.sender, _to, _value);

        return true;
    }

    function balanceOf(address _owner) constant returns (uint) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool) {
        if (balances[_from] < _value || allowed[_from][msg.sender] < _value || _value <= 0) {
            return false;
        }

        transferFunds(_from, _to, _value);
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint _value) returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
        totalSupply += _amount; // @todo safe math
        balances[_to] += _amount;

        Mint(_to, _amount);
        return true;
    }

    function finishMinting() onlyOwner returns (bool) {
        mintFinished = true;
        MintFinished();
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint) {
        return allowed[_owner][_spender];
    }

    function isSafeToAdd(uint left, uint right) private returns (bool) {
        return (left + right >= left);
    }

    function isSafeToSubtract(uint left, uint right) private returns (bool) {
        return (right <= left);
    }

    function transferFunds(address _from, address _to, uint _value) private {
        if (!isSafeToAdd(balances[_to], _value) || !isSafeToSubtract(balances[_from], _value)) {
            throw;
        }

        balances[_to] += _value;
        balances[_from] -= _value;
    }
}
