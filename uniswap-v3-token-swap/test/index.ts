import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import { SwapExamples } from "../typechain/SwapExamples";

describe('Swap', () => {
  let signer: SignerWithAddress, 
    swaper: SwapExamples, 
    weth_contract: Contract, 
    dai_contract: Contract,
    usdc_contract: Contract,
    balance: string, 
    num_weth: string;
    const erc_abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"guy","type":"address"},{"name":"wad","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"src","type":"address"},{"name":"dst","type":"address"},{"name":"wad","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"wad","type":"uint256"}],"name":"withdraw","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"dst","type":"address"},{"name":"wad","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"deposit","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"},{"name":"","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"src","type":"address"},{"indexed":true,"name":"guy","type":"address"},{"indexed":false,"name":"wad","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"src","type":"address"},{"indexed":true,"name":"dst","type":"address"},{"indexed":false,"name":"wad","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"dst","type":"address"},{"indexed":false,"name":"wad","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"src","type":"address"},{"indexed":false,"name":"wad","type":"uint256"}],"name":"Withdrawal","type":"event"}]

    const weth_addr = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
    const dai_addr = '0x6B175474E89094C44Da98b954EedeAC495271d0F'
    const usdc_addr = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'

  before(async ()=> {
      const signers = await ethers.getSigners(); 
      signer = signers[0];

      const SwapExample = await ethers.getContractFactory("SwapExamples");
      swaper = await SwapExample.deploy('0xE592427A0AEce92De3Edee1F18E0157C05861564');
      await swaper.deployed();

      
      weth_contract = new ethers.Contract(weth_addr, erc_abi, signer)
      dai_contract = new ethers.Contract(dai_addr, erc_abi, signer)
      usdc_contract = new ethers.Contract(usdc_addr, erc_abi, signer)

      balance = ethers.utils.formatEther((await signer.getBalance()))
      num_weth = ethers.utils.formatEther((await weth_contract.balanceOf(signer.address)))
      expect(num_weth).to.equal('0.0')
      
      console.log('ETH Balance: ', balance)
      console.log('WETH Balance: ', num_weth)
      console.log('---')
  })
  it('swaps ETH to WETH', async () => {

    const overrides = {
      value: ethers.utils.parseEther('50'),
      gasLimit: ethers.utils.hexlify(50000), 
    }
    let tx = await weth_contract.deposit(overrides)
    await tx.wait()
  
    balance = ethers.utils.formatEther((await signer.getBalance()))
    num_weth = ethers.utils.formatEther((await weth_contract.balanceOf(signer.address)))
    expect(num_weth).to.equal('50.0')
  
    console.log('ETH Balance: ', balance)
    console.log('WETH Balance: ', num_weth)
    console.log('---')
  })

  it('swaps WETH for DAI', async () => {
    let tx = await weth_contract.approve(swaper.address, ethers.utils.parseEther('10'))
    await tx.wait()
    tx = await swaper.swapExactInputSingle(ethers.utils.parseEther('10'), 2000, weth_addr, dai_addr) // amountIn, minAmountOut, tokenIn, tokenOut
    await tx.wait()
  
    num_weth = ethers.utils.formatEther((await weth_contract.balanceOf(signer.address)))
    let num_dai = ethers.utils.formatEther((await dai_contract.balanceOf(signer.address)))
    expect(num_weth).to.equal('40.0')
  
    console.log('WETH Balance: ', num_weth)
    console.log('DAI Balance: ', num_dai)
  })  
  it('swaps WETH for USDC', async () => {
    let tx = await weth_contract.approve(swaper.address, ethers.utils.parseEther('10'))
    await tx.wait()
    tx = await swaper.swapExactInputSingle(ethers.utils.parseEther('10'), ethers.utils.parseUnits('35000', 6), weth_addr, usdc_addr) // amountIn, minAmountOut, tokenIn, tokenOut
    await tx.wait()
  
    num_weth = ethers.utils.formatEther((await weth_contract.balanceOf(signer.address)))
    let num_usdc = ethers.utils.formatUnits(await usdc_contract.balanceOf(signer.address), 6)
    expect(num_weth).to.equal('30.0')
  
    console.log('WETH Balance: ', num_weth)
    console.log('USDC Balance: ', num_usdc)
  })
  it('swaps USDC for WETH', async () => {
    let tx = await usdc_contract.approve(swaper.address, ethers.utils.parseUnits('5000', 6))
    await tx.wait()
    tx = await swaper.swapExactInputSingle(ethers.utils.parseUnits('5000', 6), ethers.utils.parseEther('1'), usdc_addr, weth_addr) // amountIn, minAmountOut, tokenIn, tokenOut
    await tx.wait()
  
    num_weth = ethers.utils.formatEther((await weth_contract.balanceOf(signer.address)))
    let num_usdc = ethers.utils.formatUnits(await usdc_contract.balanceOf(signer.address), 6)
    expect(Number(num_usdc)).to.be.above(31.0)

    console.log('WETH Balance: ', num_weth)
    console.log('USDC Balance: ', num_usdc)
  })
})
