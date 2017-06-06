const MyToken = artifacts.require('./tokens/Token.sol');

let token;

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

    // it('should try to transfer from account[1] to accounts[0] with a value of 1 HRB but fail', function () {
    //     let token;
    //     let balanceOfAccounts1;
    //     let balanceOfAccounts2;

    //     return MyToken.deployed("Harbour", "HRB").then(function (instance) {
    //         token = instance;
    //         return token.transfer(accounts[0], 1000000000000000000, { from: accounts[1] });
    //     }).then(function () {
    //         return token.balanceOf.call(accounts[0])
    //     }).then(function (balance) {
    //         balanceOfAccounts1 = balance.valueOf();
    //         return token.balanceOf.call(accounts[1])
    //     }).then(function (balance) {
    //         balanceOfAccounts2 = balance.valueOf();

    //         assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 HRB');
    //         assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 HRB');
    //     });

    // });

    // it('should try to transfer from account[0] to accounts[1] with a value of 651,000 HRB but fail', function () {
    //     let token;
    //     let balanceOfAccounts1;
    //     let balanceOfAccounts2;

    //     return MyToken.deployed("Harbour", "HRB").then(function (instance) {
    //         token = instance;
    //         return token.transfer(accounts[1], 651000000000000000000000, { from: accounts[0] });
    //     }).then(function () {
    //         return token.balanceOf.call(accounts[0])
    //     }).then(function (balance) {
    //         balanceOfAccounts1 = balance.valueOf();
    //         return token.balanceOf.call(accounts[1])
    //     }).then(function (balance) {
    //         balanceOfAccounts2 = balance.valueOf();

    //         assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 HRB');
    //         assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 HRB');
    //     });

    // });

    // it('should try to transfer from account[0] to accounts[1] with a value of -1 HRB but fail', function () {
    //     let token;
    //     let balanceOfAccounts1;
    //     let balanceOfAccounts2;

    //     return MyToken.deployed("Harbour", "HRB").then(function (instance) {
    //         token = instance;
    //         return token.transfer(accounts[1], -1000000000000000000, { from: accounts[0] });
    //     }).then(function () {
    //         return token.balanceOf.call(accounts[0])
    //     }).then(function (balance) {
    //         balanceOfAccounts1 = balance.valueOf();
    //         return token.balanceOf.call(accounts[1])
    //     }).then(function (balance) {
    //         balanceOfAccounts2 = balance.valueOf();

    //         assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 HRB');
    //         assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 HRB');
    //     });

    // });

    // it('should try to transfer from account[0] to accounts[1] with a value of 0 HRB but fail', function () {
    //     let token;
    //     let balanceOfAccounts1;
    //     let balanceOfAccounts2;

    //     return MyToken.deployed("Harbour", "HRB").then(function (instance) {
    //         token = instance;
    //         return token.transfer(accounts[1], 0, { from: accounts[0] });
    //     }).then(function () {
    //         return token.balanceOf.call(accounts[0])
    //     }).then(function (balance) {
    //         balanceOfAccounts1 = balance.valueOf();
    //         return token.balanceOf.call(accounts[1])
    //     }).then(function (balance) {
    //         balanceOfAccounts2 = balance.valueOf();

    //         assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 HRB');
    //         assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 HRB');
    //     });

    // });

});