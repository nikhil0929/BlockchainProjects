// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AMM {
    uint256 public token1_total; //token1 total supply
    uint256 public token2_total; //token2 total supply
    uint256 public total_shares; //total shares distributed to liquidity providers (LP)

    uint256 public K; // Constant K that represents the market constant: token1_total * token2_total = K

    mapping(address => uint256) public user_shares; // mapping of LP addresses to the shares they own

    IERC20 immutable token1;
    IERC20 immutable token2;

    constructor(address token1_address, address token2_address) {
        token1 = IERC20(token1_address);
        token2 = IERC20(token2_address);
    }

    /////////// PRIVATE FUNCTIONS \\\\\\\\\\\

    function _sqrt(uint256 x) private pure returns (uint256 z) {
        if (x > 3) {
            z = x;
            uint256 y = x / 2 + 1;
            while (y < z) {
                z = y;
                y = (x / y + y) / 2;
            }
        } else if (x != 0) {
            z = 1;
        }
    }

    /////////// MODIFIER FUNCTIONS \\\\\\\\\\\

    modifier canSupplyToken(
        address sdr,
        uint256 token_in,
        IERC20 token_type
    ) {
        require(
            token_in > 0,
            "Amount of tokens supplied must be greater than 0"
        );
        require(
            (token_type.balanceOf(sdr) - token_in) > 0,
            "user does not have enough tokens to send"
        );
        _;
    }

    modifier hasValidShareAmount(uint256 share) {
        require(share > 0, "Share input amount must be greater than 0");
        require(
            share <= total_shares,
            "Share input amount cannot exceed total number of shares"
        );
        _;
    }

    /////////// CONTRACT FUNCTIONS \\\\\\\\\\\

    // Function allows users to add liquidity to the pool and gives them shares in return
    // if the liquidity pool is originally empty, then
    function AddLiquidity(uint256 token1_in, uint256 token2_in)
        public
        canSupplyToken(msg.sender, token1_in, token1)
        canSupplyToken(msg.sender, token2_in, token2)
        returns (uint256)
    {
        // Check if msg.sender has enough funds to run this transaction for the specified amount
        // Withdraw token1_in and token2_in amounts from msg.sender
        // if no shares exist (new AMM created):
        //      - share_amount = sqrt(token1_in * token2_in)
        // if shares DO exist:
        //      - share1 = (token1_in / token1_total) * total_shares
        //      - share2 = (token2_in / token2_total) * total_shares
        //      - check if share1 == share2 (for now: this makes it easier to distribute shares)
        //      - share_amount = share1
        // set user_shares[msg.sender] = share_amount
        // increase token1_total / token2_total by token1_in / token2_in
        // recalculate constant K: K = token1_total * token2_total
        // return share amount

        bool didTransfer = token1.transferFrom(
            msg.sender,
            address(this),
            token1_in
        );
        didTransfer =
            token2.transferFrom(msg.sender, address(this), token2_in) &&
            didTransfer;

        require(didTransfer, "Token transfer was not successful");

        uint256 share_amount;
        if (total_shares == 0) {
            // share_amount = sqrt(token1_in * token2_in)
            share_amount = _sqrt(token1_in * token2_in);
        } else {
            // share1 = (token1_in / token1_total) * total_shares
            uint256 share1 = (token1_in / token1_total) * total_shares;

            // share2 = (token2_in / token2_total) * total_shares
            uint256 share2 = (token2_in / token2_total) * total_shares;

            require(
                share1 == share2,
                "equivalent number of tokens not supplied (50:50 AMM)"
            );

            share_amount = share1;
        }
        user_shares[msg.sender] = share_amount;
        token1_total = token1.balanceOf(address(this));
        token2_total = token2.balanceOf(address(this));

        K = token1_total * token2_total;

        return share_amount;
    }

    // Function allows users with shares in the liquidity pool to "cash in" their shares for the tokens they put in
    function WithdrawLiquidity(uint256 share)
        public
        hasValidShareAmount(share)
        returns (uint256, uint256)
    {
        /*
        - Make sure share > 0
        - Make sure share <= total_shares

        - Calculate token amount for given amount of shares:
            - amount_tokenX = (share / total_shares) * total_tokenX  <== do this for both token1 and token1
        - Remove liquidity from pool:
            - total_tokenX =  -= amount_tokenX
        - Reduce msg.sender's share amount from mapping
        - Reduce total_shares amount by share
        - Transfer tokenX from this contract to msg.sender

        */
        uint256 amount_token1 = (share / total_shares) * token1_total;
        uint256 amount_token2 = (share / total_shares) * token1_total;

        token1_total -= amount_token1;
        token2_total -= amount_token2;

        user_shares[msg.sender] -= share;
        total_shares -= share;

        K = token1_total * token2_total;

        token1.transferFrom(address(this), msg.sender, amount_token1);
        token2.transferFrom(address(this), msg.sender, amount_token2);

        return (amount_token1, amount_token2);
    }

    // function SwapToken(address token_address, uint256 token_amount)
    //     public
    //     canSupplyToken(msg.sender, token_amount, token_address)
    //     returns (uint256 return_token_amount)
    // {
    //     /*
    //     - Check if user has supplied valid token amount
    //     */

    //     (IERC20 token_in, IERC20 token_out) = token_address == token1
    //         ? (token1, token2)
    //         : (token2, token1);

    //     token_in.transferFrom(msg.sender, address(this), token_amount);
    //     uint256 fee_token_in = (token_amount * 995) / 1000;

    //     uint256 token_out_amt =

    // }

    function swapToken_1to2(uint256 token_amount)
        public
        canSupplyToken(msg.sender, token_amount, token1)
        returns (uint256 return_token_amount)
    {
        /*
        - Check if user has supplied valid token amount
        */

        token1.transferFrom(msg.sender, address(this), token_amount);
        uint256 final_token1 = token1.balanceOf(address(this));

        uint256 final_token2 = K / final_token1;
        return_token_amount = token2_total - final_token2;

        // Take a 0.5% fee
        return_token_amount = (return_token_amount * 995) / 1000;

        token2.transfer(msg.sender, return_token_amount);

        //update token1_amount, and token2_amount

        token1_total = final_token1;
        token2_total = token2.balanceOf(address(this));
        //update K

        K = token1_total * token2_total;
    }

    // Separated the functions to because of the reduced gas fees
    function swapToken_2to1(uint256 token_amount)
        public
        canSupplyToken(msg.sender, token_amount, token2)
        returns (uint256 return_token_amount)
    {
        /*
        - Check if user has supplied valid token amount
        */

        token2.transferFrom(msg.sender, address(this), token_amount);
        uint256 final_token2 = token2.balanceOf(address(this));

        uint256 final_token1 = K / final_token2;
        return_token_amount = token1_total - final_token1;

        // Take a 0.5% fee
        return_token_amount = (return_token_amount * 995) / 1000;

        token1.transfer(msg.sender, return_token_amount);

        //update token1_amount, and token2_amount

        token2_total = final_token2;
        token1_total = token2.balanceOf(address(this));
        //update K

        K = token1_total * token2_total;
    }
}
