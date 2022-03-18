# Deploy Basic Sample Hardhat Project Using Moralis

```bash
npm init --yes                                        
npm install --save-dev hardhat
npx hardhat 
```

-> Select basic sample project
Create secret.json file in root directory of project with this content:
{
    "key": "",
    "url": ""
}
Go to [moralis](https://moralis.io/) / [infura](https://infura.io/) / [alchemy](https://www.alchemy.com/)

On Moralis -> Click on Speedy Node -> Copy the address of the network you want to deploy to ( For example Ethereums Ropstentestnetwork ) -> Paste that address as url in the secret.json
![Speedy Node](https://i.imgur.com/vtHYPwZ.png)
![Network Address](https://i.imgur.com/pqCs0k5.png)

In your Metamask(can be any provider) select the network (or add if its not there: [networks](https://rpc.info/) ) and account you want to use and [export your private key](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key) and add it as key to the secret.json.
Make sure you have some ETH to test on that network. ( You can get it from a faucet just google Ropsten faucet if you use ropsten ) 
[list of faucets](https://github.com/arddluma/awesome-list-testnet-faucets)
In your hardhat.config.js on top add:

```bash
let secret = require("./secret");
```

in the same file add below the solidity compiler version: ( instead of ropsten you can add your network name )

```bash
  networks: {
    ropsten: {
      url: secret.url,
      accounts: [secret.key]
    }
  }
```

Now you can deploy the sample contract:

```bash
npx hardhat run scripts/sample-script.js --network ropsten
```

To verify that the contract is deployed copy the deployed contract hash from the terminal and use the respective scanner.

[Polygon mumbai](https://mumbai.polygonscan.com/)
[Ethereum Ropsten](https://ropsten.etherscan.io/)
[Binance Testnet](https://testnet.bscscan.com/)
[Arbitrum Testnet](https://testnet.arbiscan.io/)

There are more just google.
