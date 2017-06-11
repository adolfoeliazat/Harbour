pragma solidity ^0.4.11;

contract ERC20 {
<<<<<<< HEAD
    function approve(address _spender, uint _value) returns (bool);
    function totalSupply() constant returns (uint);
    function transferFrom(address _from, address _to, uint _value) returns (bool);
    function balanceOf(address _owner) constant returns (uint);
    function transfer(address _to, uint _value) returns (bool);
    function allowance(address _owner, address _spender) constant returns (uint);
=======
    uint public totalSupply;
    
    function totalSupply() constant returns (uint);
    function balanceOf(address _owner) constant returns (uint);
    function allowance(address _owner, address _spender) constant returns (uint);
    function transfer(address _to, uint _value) returns (bool);
    function transferFrom(address _from, address _to, uint _value) returns (bool);
    function approve(address _spender, uint _value) returns (bool);
    
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
>>>>>>> development
}
