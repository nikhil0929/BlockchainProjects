const AMM = artifacts.require("AMM");
const TestToken1 = artifacts.require("TestToken1");
const TestToken2 = artifacts.require("TestToken2");

contract("TestToken", (accounts) => {
    it("deployed test token contracts should have 10000 tokens each", async () => {
        const token1Instance = await TestToken1.deployed();
        const token2Instance = await TestToken2.deployed();

        const token1Balance = await token1Instance.balanceOf(accounts[0]);
        const token2Balance = await token2Instance.balanceOf(accounts[0]);

        assert.equal(token1Balance, 10000);
        assert.equal(token2Balance, 10000);
    })
})

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

    it("should allow user to provide fixed (50:50) to empty liquidty pool and get sqrt(1000 * 1000) shares back", async () => {
        // Approve the AMM contract to spend the tokens on behalf of the user
        await token1Instance.approve(ammInstance.address, 1000);
        await token2Instance.approve(ammInstance.address, 1000);

        // Provide liquidity to the pool
        await ammInstance.AddLiquidity(1000, 1000);

        // Check that the user has sqrt(1000 * 1000) shares
        const userShares = await ammInstance.user_shares(accounts[0]);
        assert.equal(userShares, Math.sqrt(1000 * 1000));
    });
});