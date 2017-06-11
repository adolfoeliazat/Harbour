const Configuration = artifacts.require('Configuration.sol');
const utils = require('./helpers/Utils.js');

let config;

contract('Configuration', function (accounts) {

    let shouldntFail = function (err) {
        assert.isFalse(!!err);
    };

    beforeEach(async () => {
        config = await Configuration.new();
    });

    it('verifies that owner can set values', async () => {
        let key = "foo";
        let value = 12;

        await config.set(key, value);

        assert.equal(await config.get.call(key), value, 'value was not set correctly');
     });

     it('should fail when non admin tries to edit a value', async () => {
        let key = "foo";
        let value = 12;

        await config.set(key, value);

        try {
            let result = await config.set(key, value + 1, { from: accounts[1] });
        } catch (error) {
            return utils.ensureException(error);
        }

        assert.fail("setting value did not fail");
     });

     it('should fail when admin tries to edit a protected value', async () => {
        let key = "foo";
        let value = 12;

        await config.set(key, value);

        config.addAdmin(accounts[1]);
        await config.protect(key);

        try {
            let result = await config.set(key, value + 1, { from: accounts[1] });
        } catch (error) {
            return utils.ensureException(error);
        }

        assert.fail("setting value did not fail");
     });

    it('verifies that admin can change value', async () => {
        let key = "foo";
        let value = 12;
        let newValue = 13;

        await config.set(key, value);

        config.addAdmin(accounts[1]);

        await config.set(key, newValue, { from: accounts[1] });
        
        assert.equal(await config.get.call(key), newValue, 'value was not set correctly');
     });

    it('verifies that owner can change protected value', async () => {
        let key = "foo";
        let value = 12;
        let newValue = 13;

        await config.set(key, value);
        await config.protect(key);
        await config.set(key, newValue);
        
        assert.equal(await config.get.call(key), newValue, 'value was not set correctly');
     });
});
