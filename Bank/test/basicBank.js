const BasicBank = artifacts.require("BasicBank");
var assert = require('assert');

contract("BasicBank", accounts => {
    const account_one = accounts[0];
    let basicBank;
    before(async() => {
        // runs once before the first test in this block
        basicBank = await BasicBank.deployed();
      });

    it("should create an account", async () => {
        await basicBank.openAccount({from: account_one});
        const result = await basicBank.doesAccountExist(account_one);
        assert.equal(result, true);
    });

    it("should deposit to an existing account", async () => {
        await basicBank.deposit({from: account_one, value: 1});
        const result = await basicBank.getBalance(account_one);
        assert.equal(result, 1);
    });

    it("should withdraw from an existing account", async () => {
        await basicBank.withdraw(1, {from: account_one});
        const result = await basicBank.getBalance(account_one);
        assert.equal(result, 0);
    });

    it("should close an existing account", async () => {
        await basicBank.closeAccount({from: account_one});
        const result = await basicBank.doesAccountExist(account_one);
        assert.equal(result, false);
    });
});
