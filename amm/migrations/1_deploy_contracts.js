const AMM = artifacts.require("AMM");

const etherToken = "0x2170ed0880ac9a755fd29b2688956bd959f933f8"
const shibaToken = "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"

module.exports = function(deployer) {
  deployer.deploy(AMM, etherToken, shibaToken);
};
