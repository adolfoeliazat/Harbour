pragma solidity ^0.4.11;

import "./Token.sol";

contract TokenSale {

    Token public token;

    address public tokenateMultisig; // @todo add a nicer way, aka allocations object.
    address public devMultisig;
    address public beneficiary;
    address[] public developers;

    uint public hardCap;
    uint public softCap;
    uint public collected;
    uint public price;
    uint public purchaseLimit;

    bool public softCapReached = false;
    bool public tokenateAllocated = false;
    bool public devAllocated = false;

    event GoalReached(uint amountRaised);
    event SoftCapReached(uint softCap);
    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);

    function TokenSale(uint _hardCap, uint _softCap, address _token, uint _price, uint _purchaseLimit) {
        hardCap = _hardCap * 1 ether;
        softCap = _softCap * 1 ether;
        price = _price;
        purchaseLimit = _purchaseLimit * 1 ether;
        token = Token(_token);
    }

    function () payable {
        doPurchase(msg.sender);
    }

    function allocateTokenateTokens() {
        if (tokenateAllocated) throw;
        allocate(tokenateMultisig, 100000);
        tokenateAllocated = true;
    }

    function allocateDeveloperTokens() {
        if (devAllocated) throw;

        uint tokensPerDev = 25000;
        uint tokensPerWallet = tokensPerDev / 2;

        for (uint i = 0; i < developers.length; i++) {
            allocate(devMultisig, tokensPerWallet);
            allocate(developers[i], tokensPerWallet);
        }

        devAllocated = true;
    }

    function doPurchase(address _owner) private {
        if (collected + msg.value > hardCap) throw;

        if (!softCapReached && collected < softCap && collected + msg.value >= softCap) {
            softCapReached = true;
            SoftCapReached(softCap);
        }

        uint amount = msg.value;
        uint tokens = amount * price;

        // Ensure we are not surpassing the purchasing limit per address
        if (amount > purchaseLimit) throw;
        if ((token.balanceOf(_owner) / price) + amount > purchaseLimit) throw;

        if (!beneficiary.send(msg.value)) throw;

        collected += msg.value;

        token.transfer(_to, _amount);
        NewContribution(_owner, tokens, msg.value);
    }
}
