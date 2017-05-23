const MyToken = artifacts.require('./tokens/Token.sol');

contract('Token', function (accounts) {

    it('should call totalSupply and return 650,000 FND', function () {
        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            return instance.totalSupply.call();
        }).then(function (value) {
            assert.equal(value.valueOf(), 650000000000000000000000, 'it is should have returned 650,000');
        });
    });


    it('should call balanceOf with the owner and return 650,000 FND', function () {
        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            return instance.balanceOf.call(accounts[0]);
        }).then(function (value) {
            assert.equal(value.valueOf(), 650000000000000000000000, 'it is should have returned 650,000');
        });
    });

    it('should call balanceOf with a random address and return 0 FND', function () {
        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            return instance.balanceOf.call(accounts[1]);
        }).then(function (value) {
            assert.equal(value.valueOf(), 0, 'it is should have returned 0');
        });
    });


    it('should call transfer to accounts[1] with a value of 1', function () {
        let token;
        let result;
        let balanceOfAccounts1;
        let balanceOfAccounts2;

        return MyToken.deployed("The Fund", "FND", 650000).then(function (instance) {
            token = instance;
            return token.transfer.call(accounts[1], 1, {from: accounts[0]});
        }).then(function (res) {
            result = res;
            console.log(result)
            return token.balanceOf.call(accounts[0])
        }).then(function (balance) {
            balanceOfAccounts1 = balance.valueOf();
            return token.balanceOf.call(accounts[1])
        }).then(function (balance) {
            balanceOfAccounts2 = balance.valueOf();

            assert.equal(result, true, 'it is should have returned true');
            assert.equal(balanceOfAccounts1, 649999000000000000000000, 'it is should have returned 649,000');
            assert.equal(balanceOfAccounts2, 1000000000000000000, 'it is should have returned 1');

        });

    });

});