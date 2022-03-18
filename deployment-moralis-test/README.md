# Deploy Basic Sample Hardhat Project On Moralis
npm init --yes                                        
npm install --save-dev hardhat
npx hardhat 
-> Select basic sample project
Create secret.json file in root directory of project with this content:
{
    "key": "",
    "url": ""
}
Go to moralis / infura / alchemy -> https://moralis.io/
On Moralis -> Click on Speedy Node -> Copy the address of the network you want to deploy to ( For example Ethereums Ropstentestnetwork ) -> Paste that address as url in the secret.json
In your Metamask(can be any provider) select the network (or add if its not there https://rpc.info/ ) and account you want to use and export your private key and add it as key to the secret.json.
Make sure you have some ETH to test on that network. ( You can get it from a faucet just google Ropsten faucet if you use ropsten )
In your hardhat.config.js on top add:
let secret = require("./secret");
in the same file add below the solidity compiler version: ( instead of ropsten you can add your network name )
  networks: {
    ropsten: {
      url: secret.url,
      accounts: [secret.key]
    }
  }
Now you can deploy the sample contract:
npx hardhat run scripts/sample-script.js --network ropsten