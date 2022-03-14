const Timelock = artifacts.require("Timelock");

module.exports = (deployer, network, accounts) => {
  deployer.deploy(Timelock, 360, [], []);
};
