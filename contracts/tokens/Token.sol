pragma solidity ^0.4.11;

import "../ownership/ownable.sol";
import "../SafeMath.sol";

contract Token is ownable {
    using SafeMath for uint;

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
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool) {
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);

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
}
