// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AMM {
    using SafeMath for uint256;

    uint256 token1_total; //token1 total supply
    uint256 token2_total; //token2 total supply
    uint256 total_shares; //total shares distributed to liquidity providers (LP)

    uint256 K; // Constant K that represents the market constant: token1_total * token2_total = K

    mapping(address => uint256) user_shares; // mapping of LP addresses to the shares they own

    IERC20 immutable token1;
    IERC20 immutable token2;

    constructor(address token1_address, address token2_address) public {
        token1 = IERC20(token1_address);
        token2 = IERC20(token2_address);
    }

    // Function allows users to add liquidity to the pool and gives them shares in return
    // if the liquidity pool is originally empty, then
    function AddLiquidity(uint256 token1_in, uint256 token2_in)
        public
        returns (uint256 share)
    {
        // Check if msg.sender has enough funds to run this transaction for the specified amount
        // Withdraw token1_in and token2_in amounts from msg.sender
        // if no shares exist (new AMM created):
        //      - set rate to token1_in : token2_in :: token1_total : token2_total
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
    }

    function WithdrawLiquidity(uint256 share)
        public
        returns (uint256 token1, uint256 token2)
    {}

    function SwapToken(uint256 token_amount)
        public
        returns (uint256 return_token_amount)
    {}
}
