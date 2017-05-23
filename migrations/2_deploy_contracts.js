var Token = artifacts.require("./tokens/Token.sol");
var TokenSale = artifacts.require("./tokens/TokenSale.sol");
var TokenWallet = artifacts.require("./wallets/TokenWallet.sol");


module.exports = function (deployer) {

  var _name = "The Fund";
  var _symbol = "FND";
  var _supply = 650000;
  var _hardcap = 100000
  var _softcap = 5000;
  var _price = 5;
  var _purchaseLimit = 5000;

  deployer.deploy(Token, _name, _symbol, _supply).then(function () {
    deployer.deploy(TokenWallet).then(function () {
        deployer.deploy(TokenSale, _hardcap, _softcap, Token.address, _price, _purchaseLimit, TokenWallet.address);
    });
  });
};
