require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");

const { alchemyApiKey, GOERLI_PRIVATE_KEY } = require('./secrets.json');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  network: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
      accounts: [GOERLI_PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: "YXUTV5W4Q8J17NEA799D7EJTGFZYW8F6GS"
  }
};
