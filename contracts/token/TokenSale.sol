pragma solidity ^0.4.11;

import "./Token.sol";

contract TokenSale {

    Token public token;

    address public tokenateMultisig;
    address public devMultisig;
    address public fundWallet;
    address[] public developers;

    uint public startBlock;
    uint public endBlock;
    uint public cap;
    uint public collected;
    uint public price;
    uint public purchaseLimit;

    bool public tokenateAllocated = false;
    bool public devAllocated = false;

    modifier onlyBeforeBlock(uint block) {
        if (block.number > block) throw;
        _;
    }

    modifier onlyAfterBlock(uint block) {
        if (block.number > block) throw;
        _;
    }

    function TokenSale(uint _cap) {
        cap = _cap * 1 ether;
    }

    function () payable {
        doPayment(msg.sender);
    }

    function allocateTokenateTokens() onlyAfterBlock(endBlock) {
        if (tokenateAllocated) throw;
        allocate(tokenateMultisig, 100000);
        tokenateAllocated = true;
    }

    function allocateDeveloperTokens() onlyAfterBlock(endBlock) {
        if (devAllocated) throw;

        uint tokensPerDev = 25000;
        uint tokensPerWallet = tokensPerDev / 2;

        // @todo for dev send to multisig and to dev wallet
    }

    function doPurchase(address _owner) onlyBeforeBlock(endBlock) onlyAfterBlock(startBlock) private {
        if (collected + msg.value > cap) throw;

        // @todo safe multiply
        uint tokens = msg.value * price;

        // Ensure we are not surpassing the purchasing limit per address
        if (tokens > purchaseLimit) throw;
        if (token.balanceOf(_owner) + tokens > purchaseLimit) throw;

        if (!fundWallet.send(msg.value)) throw;

        collected += msg.value;

        allocate(_owner, tokens);
    }

    function allocate(address _to, uint _amount) private {
        token.transfer(_to, _amount);
    }
}
