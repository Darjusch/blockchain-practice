const ExtendedBank = artifacts.require("ExtendedBank");
const TestToken = artifacts.require("TestToken");
var assert = require('assert');




contract("ExtendedBank", accounts => {
    const account_one = accounts[0];
    let extendedBank;
    let token_one;

    before(async() => {
        extendedBank = await ExtendedBank.deployed();
        token_one = await TestToken.deployed();
      });


    it("should deposit token to an existing account", async () => {
        await extendedBank.openAccount({from: account_one});
        await token_one.approve(extendedBank.address, 1000, {from: account_one});
        await extendedBank.depositToken(token_one.address, 1000, {from: account_one});
        const result = await extendedBank.checkTokenBalance(token_one.address);
        assert.equal(result, 1000);
    });
    it("should withdraw token from an existing account", async () => {
        await extendedBank.withdrawToken(token_one.address, 500, {from: account_one});
        const result = await extendedBank.checkTokenBalance(token_one.address);
        assert.equal(result, 500);
    });
});
