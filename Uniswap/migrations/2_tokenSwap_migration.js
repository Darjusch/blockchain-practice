const TokenSwap = artifacts.require("TokenSwap");

module.exports = function (deployer) {
  deployer.deploy(TokenSwap, 0xE592427A0AEce92De3Edee1F18E0157C05861564);
};
