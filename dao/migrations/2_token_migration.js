const MyToken = artifacts.require("MyToken");

module.exports = async (deployer, network, accounts) => {
  deployer.deploy(MyToken);
};
