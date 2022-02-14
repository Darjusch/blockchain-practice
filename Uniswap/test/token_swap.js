const TokenSwap = artifacts.require("TokenSwap");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("TokenSwap", function (/* accounts */) {
  it("should assert true", async function () {
    await TokenSwap.deployed();
    return assert.isTrue(true);
  });
});
