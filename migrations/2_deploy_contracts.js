var SafeMath = artifacts.require('SafeMath.sol');
var Configuration = artifacts.require("./dao/Configuration.sol");

module.exports = async (deployer) => {
  deployer.deploy(Configuration);
};
