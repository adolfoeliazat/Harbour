const MyToken = artifacts.require('./tokens/Token.sol');

contract('Token', function (accounts) {

    it('should call totalSupply and return 650,000 FND', function () {
        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            return instance.totalSupply.call();
        }).then(function (value) {
            assert.equal(value.valueOf(), 650000000000000000000000, 'totalSupply should be 650,000 FND');
        });
    });

    it('should call balanceOf with the owner and return 650,000 FND', function () {
        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            return instance.balanceOf.call(accounts[0]);
        }).then(function (value) {
            assert.equal(value.valueOf(), 650000000000000000000000, 'BalanceOf owner should be 650,000 FND');
        });
    });

    it('should call balanceOf with a random address and return 0 FND', function () {
        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            return instance.balanceOf.call(accounts[1]);
        }).then(function (value) {
            assert.equal(value.valueOf(), 0, 'BalanceOf random address should be 0 FND');
        });
    });

    it('should call transfer from account[0] to accounts[1] with a value of 1 FND', function () {
        let token;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer(accounts[1], 1000000000000000000, { from: accounts[0] });
        }).then(function () {
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(balanceOfAccounts1, 649999000000000000000000, 'new balance of owner should be 649,000 FND');
            assert.equal(balanceOfAccounts2, 1000000000000000000, 'new balance of accounts[1] should be 1 FND');
        });

    });

    it('should call transfer from account[1] to accounts[0] with a value of 1 FND', function () {
        let token;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer(accounts[0], 1000000000000000000, { from: accounts[1] });
        }).then(function () {
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(balanceOfAccounts1, 650000000000000000000000, 'new balance of owner should be 650,000 FND');
            assert.equal(balanceOfAccounts2, 0, 'new balance of accounts[1] should be 0 FND');
        });

    });

    it('should call transfer and fire an event', function (done) {
        let watcher;
        let token;
        MyToken.deployed("The Fund", "FND", 650000).then((instance) => {
            token = instance
            return token.transfer(accounts[1], 1000000000000000000, { from: accounts[0] })
        }).then((result) => {
            for (var i = 0; i < result.logs.length; i++) {
                var log = result.logs[i];
                if (log.event === "Tradnsfer") {
                    assert(log.args.from, accounts[0], 'The event\'s from address should be equal to accounts[0]')
                    assert(log.args.to, accounts[1], 'The event\'s to address should be equal to accounts[1]')
                    assert(log.args.value.valueOf(), 1000000000000000000, 'The event\'s value should be equal to 1 ETH')
                    done();
                    break;
                }
            }
        });
    });

    it('should try to transfer from account[1] to accounts[0] with a value of 1 FND but fail', function () {
        let token;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer(accounts[0], 1000000000000000000, { from: accounts[1] });
        }).then(function () {
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 FND');
            assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 FND');
        });

    });

    it('should try to transfer from account[0] to accounts[1] with a value of 651,000 FND but fail', function () {
        let token;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer(accounts[1], 651000000000000000000000, { from: accounts[0] });
        }).then(function () {
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 FND');
            assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 FND');
        });

    });

    it('should try to transfer from account[0] to accounts[1] with a value of -1 FND but fail', function () {
        let token;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer(accounts[1], -1000000000000000000, { from: accounts[0] });
        }).then(function () {
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 FND');
            assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 FND');
        });

    });

    it('should try to transfer from account[0] to accounts[1] with a value of 0 FND but fail', function () {
        let token;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer(accounts[1], 0, { from: accounts[0] });
        }).then(function () {
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(balanceOfAccounts1, 650000000000000000000000, 'balance of owner should be 650,000 FND');
            assert.equal(balanceOfAccounts2, 0, 'balance of accounts[1] should be 0 FND');
        });

    });

});