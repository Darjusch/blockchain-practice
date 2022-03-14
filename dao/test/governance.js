const MyGovernor = artifacts.require("MyGovernor");
const MyToken = artifacts.require("MyToken");
const Timelock = artifacts.require("Timelock")
const {expect, use} = require("chai");
const { solidity } = require("ethereum-waffle");
const ethers = require("ethers");

contract("Governor", accounts => {
    use(solidity);
    const owner = accounts[0];
    const account_one = accounts[1];
    const account_two = accounts[2];
    let timelock;
    let myToken;
    let myGovernor;

    before( async () => {
        timelock = await Timelock.deployed();
        myToken = await MyToken.deployed();
        myGovernor = await MyGovernor.deployed(myToken.address, timelock.address);
    });
    it('delegates token to himself', async() => {
        const votes = Number(await myToken.getVotes(owner));
        console.log(`Votes ${votes}`);
        expect(votes).equals(0);
        await myToken.delegate(owner, {from: owner});
        const newVotes = Number(await myToken.getVotes(owner));
        console.log(`New Votes ${newVotes}`);
        expect(newVotes).equals(1000000000000000000);
    });
});