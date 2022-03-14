const MyToken = artifacts.require("MyToken");
const Timelock = artifacts.require("Timelock");
const MyGovernor = artifacts.require("MyGovernor");

module.exports = async (deployer, network, accounts) => {
  let myToken = await MyToken.deployed()
  let timelock = await Timelock.deployed()
  await deployer.deploy(MyGovernor, myToken.address, timelock.address);
};
