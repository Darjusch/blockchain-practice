var BasicBank = artifacts.require("BasicBank");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(BasicBank);
};