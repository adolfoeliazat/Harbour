const MyToken = artifacts.require('./tokens/Token.sol');

let token;

function isException(error) {
    let strError = error.toString();
    return strError.includes('invalid opcode') || strError.includes('invalid JUMP');
}

function ensureException(error) {
    assert(isException(error), error.toString());
}

contract('Token', function (accounts) {

    let shouldntFail = function (err) {
        assert.isFalse(!!err);
    };

    beforeEach(async () => {
        token = await MyToken.new("Harbour", "HRB");
    });

    it('should fire an event when mint is called', async () => { 
        let toMint = 300;
        let account = accounts[0];
        let result = await token.mint(account, toMint);

        assert.equal(result.logs[0].event, 'Mint', 'mint event not fired');
    });

    it('verifies that token mint updates totalSupply', async () => { 
        let toMint = 300;
        let account = accounts[0];
        token.mint(account, toMint);

        assert.equal(await token.totalSupply.call(), toMint, 'totalSupply does not match expected value');
    });

    it('verifies that balanceOf returns correct value after mint', async () => { 
        let toMint = 300;
        let account = accounts[0];
        let result = await token.mint(account, toMint);

        assert.equal(await token.balanceOf(account), toMint, 'balanceOf does not return expected value');
    });

    it('verifies that balanceOf returns correct value when no tokens minted', async () => { 
        assert.equal(await token.balanceOf(accounts[0]), 0, 'balanceOf does not return expected value');
    });

    it('verifies calling transfer will change account balances', async () => { 
        let toMint = 300;
        token.mint(accounts[0], toMint);
        token.transfer(accounts[1], toMint, { from: accounts[0] });

        assert.equal(await token.balanceOf(accounts[0]), 0, 'balance was not updated correctly');
        assert.equal(await token.balanceOf(accounts[1]), toMint, 'balance was not updated correctly');

    });

    it('should fire event when transfer is called', async () => { 
        let toMint = 300;
        token.mint(accounts[0], toMint);
        let result = await token.transfer(accounts[1], toMint, { from: accounts[0] });
        
        assert.equal(result.logs[0].event, 'Transfer', 'transfer event not fired');
    });

    it('should fail to transfer when account does not have enough tokens', async () => { 
        let toMint = 300;
        token.mint(accounts[0], toMint);

        let result = await token.transfer(accounts[1], toMint + 1, { from: accounts[0] });

        assert(result, false, "transfer did not fail");
    });

    it('should fail to transfer when using negative token value', async () => { 
        let toMint = 300;
        token.mint(accounts[0], toMint);

        let result = await token.transfer(accounts[1], -1, { from: accounts[0] });

        assert(result, false, "transfer did not fail");
    });

    it('should fail to transfer when transfering 0 tokens', async () => { 
        let toMint = 300;
        token.mint(accounts[0], toMint);

        let result = await token.transfer(accounts[1], 0, { from: accounts[0] });

        assert(result, false, "transfer did not fail");
    });

});
