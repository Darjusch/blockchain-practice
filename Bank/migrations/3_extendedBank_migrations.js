var ExtendedBank = artifacts.require("ExtendedBank");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(ExtendedBank);
};