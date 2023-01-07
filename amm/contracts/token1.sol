pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken1 is ERC20 {
    constructor(uint256 initialBalance) public ERC20("TestToken1", "TT1") {
        _mint(msg.sender, initialBalance);
    }

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}
