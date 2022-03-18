require("@nomiclabs/hardhat-waffle");
let secret = require("./secret");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    ropsten: {
      url: secret.ropsten_url,
      accounts: [secret.key]
    },
    mumbai: {
      url: secret.mumbai_url,
      accounts: [secret.key]
    },
    binance_testnet: {
      url: secret.binance_testnet_url,
      accounts: [secret.key]
    },
    arbitrum_testnet: {
      url: secret.arbitrum_testnet_url,
      accounts: [secret.key]
    },
  }
};
