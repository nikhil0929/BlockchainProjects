const { assert } = require("chai");

const AMM = artifacts.require("AMM");
const TestToken1 = artifacts.require("TestToken1");
const TestToken2 = artifacts.require("TestToken2");

// contract("TestToken", (accounts) => {
//     it("deployed test token contracts should have 10000 tokens each", async () => {
//         const token1Instance = await TestToken1.deployed();
//         const token2Instance = await TestToken2.deployed();

//         const token1Balance = await token1Instance.balanceOf(accounts[0]);
//         const token2Balance = await token2Instance.balanceOf(accounts[0]);

//         assert.equal(token1Balance, 0);
//         assert.equal(token2Balance, 0);
//     })
// })

contract("AMM", (accounts) => {

    let token1Instance;
    let token2Instance;
    let ammInstance;

    beforeEach(async () => {
        // Resets token1 and token2 balances for this address to 10,000 tokens each
        token1Instance = await TestToken1.deployed();
        token2Instance = await TestToken2.deployed();
        ammInstance = await AMM.deployed();
    });

    it("can mint money into 2 accounts", async () => {
        await token1Instance.mint(accounts[0], 5000);
        await token2Instance.mint(accounts[0], 5000);

        await token1Instance.mint(accounts[1], 1000);
        await token2Instance.mint(accounts[1], 1000);

        const token1Balance0 = await token1Instance.balanceOf(accounts[0]);
        const token2Balance0 = await token2Instance.balanceOf(accounts[0]);

        const token1Balance1 = await token1Instance.balanceOf(accounts[1]);
        const token2Balance1 = await token2Instance.balanceOf(accounts[1]);

        assert.equal(token1Balance0, 5000);
        assert.equal(token2Balance0, 5000);
        assert.equal(token1Balance1, 1000);
        assert.equal(token2Balance1, 1000);
    });

    it("should allow user to provide fixed (50:50) to empty liquidty pool and get sqrt(1000 * 1000) shares back", async () => {
        // Add funds to the user's account
        // await token1Instance.mint(accounts[0], 1000);
        // await token2Instance.mint(accounts[0], 1000);

        await token1Instance.approve(ammInstance.address, 1000, {from: accounts[0]});
        await token2Instance.approve(ammInstance.address, 1000, {from: accounts[0]});

        // Provide liquidity to the pool
        await ammInstance.AddLiquidity(1000, 1000, {from: accounts[0]});

        // Check that the user has sqrt(1000 * 1000) shares
        const userShares = await ammInstance.user_shares(accounts[0]);
        const token1Total = await ammInstance.token1_total();
        const token2Total = await ammInstance.token2_total();

        assert.equal(userShares, Math.sqrt(1000 * 1000));
        assert.equal(token1Total, 1000);
        assert.equal(token2Total, 1000);
    });

    it("should allow user to provide fixed (50:50) to non-empty liquidty pool and get shares back", async () => {
        // Approve the AMM contract to spend the tokens on behalf of the user
        await token1Instance.mint(accounts[0], 5000);
        await token2Instance.mint(accounts[0], 5000);

        await token1Instance.mint(accounts[1], 1000);
        await token2Instance.mint(accounts[1], 1000);

        // Provide intial liquidity to the pool
        await ammInstance.AddLiquidity(5000, 5000, {from: accounts[0]});

        // Provide additional liquidity to the pool
        await ammInstance.AddLiquidity(1000, 1000, {from: accounts[1]});

        // Check that the user has sqrt(1000 * 1000) shares
        const userShares = await ammInstance.user_shares(accounts[1]);
        const token1Total = await ammInstance.token1_total();
        const token2Total = await ammInstance.token2_total();

        assert.equal(userShares, 1000);
        assert.equal(token1Total, 6000);
        assert.equal(token2Total, 6000);
        
    });

    // NEED TO WRITE MORE TESTS
});