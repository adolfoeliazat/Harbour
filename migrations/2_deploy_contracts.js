var SafeMath = artifacts.require('SafeMath.sol');
var Token = artifacts.require("./tokens/Token.sol");
var TokenSale = artifacts.require("./tokens/TokenSale.sol");
<<<<<<< HEAD

=======
var Configuration = artifacts.require("Configuration.sol");
>>>>>>> development

module.exports = async (deployer) => {

  var _name = "Harbour";
  var _symbol = "HRB";
  var _hardcap = 50000
  var _softcap = 5000;
  var _price = 10;
  var _purchaseLimit = 5000;

  deployer.deploy(SafeMath);
  await deployer.deploy(Token, _name, _symbol);
  await deployer.deploy(TokenSale, _hardcap, _softcap, Token.address, _price, _purchaseLimit);

  deployer.link(SafeMath, [Token, TokenSale]);
  deployer.deploy(Configuration);
};
