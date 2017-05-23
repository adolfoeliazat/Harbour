pragma solidity ^0.4.11;

import "../contracts/tokens/Token.sol";
import "truffle/Assert.sol";

contract TestToken {

    function testBurnReducesTotalSupply() {
        Token token = new Token("Token", "T", 50);

        Assert.equal(token.balanceOf(this), 50 * 10**18, "Token balanceOf not as expected");

        token.burn(10 * 10**18);

        Assert.equal(token.balanceOf(this), 40 * 10**18, "Token balanceOf not as expected");
        Assert.equal(token.totalSupply(), 40 * 10**18, "Token totalSupply not as expected");
    }
}
