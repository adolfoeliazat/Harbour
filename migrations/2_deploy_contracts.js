var Token = artifacts.require("./tokens/Token.sol");
var TokenSale = artifacts.require("./tokens/TokenSale.sol");
var Ownable = artifacts.require("./ownership/ownable.sol");


module.exports = function(deployer) {

  var _name = "The Fund";
  var _symbol = "FND";
  var _supply = 650000;
  var _hardcap = 100000
  var _softcap = 5000;
  var _price = 5;
  var _purchaseLimit = 5000;

  deployer.deploy(Token, _name, _symbol, _supply).then(function(){
    deployer.link(TokenSale, Ownable);
    deployer.deploy(TokenSale, _hardcap, _softcap, Token.address, _price, _purchaseLimit );
  });
};
