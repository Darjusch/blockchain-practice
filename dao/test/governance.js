const MyGovernor = artifacts.require("MyGovernor");
const MyToken = artifacts.require("MyToken");
const Timelock = artifacts.require("Timelock");
const Target = artifacts.require("Target");
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
    let target;
    const totalAmount = 1000000000000000000;
    before( async () => {
        timelock = await Timelock.deployed();
        myToken = await MyToken.deployed();
        myGovernor = await MyGovernor.deployed(myToken.address, timelock.address);
        target = await Target.deployed();
        await myToken.approve(account_one, 1000);
        await myToken.approve(account_two, 1000);

        await myToken.transfer(account_one, 1000);
        await myToken.transfer(account_two, 1000);
    });
    it('delegates token to himself', async() => {
        const votes = Number(await myToken.getVotes(owner));
        console.log(`Votes ${votes}`);
        expect(votes).equals(0);
        await myToken.delegate(owner, {from: owner});
        const newVotes = Number(await myToken.getVotes(owner));
        console.log(`New Votes ${newVotes}`);
        expect(newVotes).equals((totalAmount - 2000));
    });
    it('delegates token to someone else', async() => {
        const votes = Number(await myToken.getVotes(account_one));
        console.log(`Votes ${votes}`);
        expect(votes).equals(0);
        await myToken.delegate(account_one, {from: account_two});
        const newVotes = Number(await myToken.getVotes(account_one));
        console.log(`New Votes ${newVotes}`);
        expect(newVotes).equals((1000));
    });
    it('creates a proposal', async() => {
        const target = await ethers.getContract("Target");
        const encodedFunctionCall = target.interface.encodeFunctionData("amazing", [77]);
        console.log(encodedFunctionCall);
        // const proposalId = await myGovernor.propose(
        //     [target.address], // target contract address
        //     [1],  // ethereum value
        //     // Function we want to call with parameters 
        //     // in abi readable format 
        //     web3.eth.abi.encodeFunctionCall( 
        //         {
        //             name: 'amazing',
        //             type: 'function',
        //             inputs: [{
        //                 type: 'uint256',
        //                 name: '_amount'
        //             }]
        //         }, ['2345675643']
        //     ), 
        //     "something description"); // description
        // console.log(proposalId);
    });

    // it('votes on proposal', async() => {

    // });

});