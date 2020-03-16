const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");

const mnemonic = "muffin cute hero crawl observe couple such uniform throw pledge maid someone";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "app/src/contracts"),
  networks: {
    development: {
      // default with truffle unbox is 8545, but we can use develop to test changes, ex. truffle migrate --network develop
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/3e0451c8f0104c82a104f50d42c83f63");
      },
      network_id: "3"
    }
  }
};
