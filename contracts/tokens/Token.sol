pragma solidity ^0.4.11;

<<<<<<< HEAD
import "../ownership/ownable.sol";
import "./ERC20.sol";
import "../SafeMath.sol";

contract Token is ERC20, ownable {
=======
import "./ERC20.sol";
import "./Mintable.sol";
import "../SafeMath.sol";

contract Token is ERC20, Mintable {
>>>>>>> development
    using SafeMath for uint;

    string public name;
    string public symbol;

    uint public decimals = 18;
    uint public totalSupply;

    mapping (address => mapping (address => uint)) allowed;
    mapping (address => uint) balances;

    function Token(string _name, string _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function totalSupply() constant returns (uint) {
        return totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) constant returns (uint) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint _value) returns (bool) {
        if (_value <= 0) {
            return false;
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool) {
        if (_value <= 0) {
            return false;
        }

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
}
