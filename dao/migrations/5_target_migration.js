const Target = artifacts.require("Target");

module.exports = (deployer, network, accounts) => {
  deployer.deploy(Target);
};
