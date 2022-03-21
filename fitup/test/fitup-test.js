const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Fitup", function () {
  it("Should create a bet", async function () {
    const Fitup = await ethers.getContractFactory("Fitup");
    const fitup = await Fitup.deploy();
    await fitup.deployed();
    const [owner, addr1, organisation] = await ethers.getSigners();
    console.log(owner.address)
    await fitup.addNgo("Test", organisation.address)
    await fitup.createBet(organisation.address, {
        from: owner.address,
        value: 100000000
    })
    const bet = await fitup.getBet(owner.address)
    console.log(bet)
    expect(bet.organisation).to.equal(organisation.address)
  
});
});
