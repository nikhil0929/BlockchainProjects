const AMM = artifacts.require("AMM");
const testToken1 = artifacts.require("TestToken1");
const testToken2 = artifacts.require("TestToken2");

// const etherToken = "0x2170ed0880ac9a755fd29b2688956bd959f933f8"
// const shibaToken = "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"

let test_token1_addy;
let test_token2_addy; 

module.exports = async function(deployer) {
  await deployer.deploy(testToken1, 10000).then(() => {
    console.log("testToken1.address: ", testToken1.address);
    test_token1_addy = testToken1.address;
  });

  await deployer.deploy(testToken2, 10000).then(() => {
    console.log("testToken2.address: ", testToken2.address);
    test_token2_addy = testToken2.address;
  });

  await deployer.deploy(AMM, test_token1_addy, test_token2_addy);
};
