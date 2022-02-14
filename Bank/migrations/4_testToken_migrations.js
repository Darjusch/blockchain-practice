var TestToken = artifacts.require("TestToken");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(TestToken, 1000000000);
};