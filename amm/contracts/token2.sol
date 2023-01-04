pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken2 is ERC20 {
    constructor(uint256 initialBalance) public ERC20("TestToken2", "TT2") {
        _mint(msg.sender, initialBalance);
    }
}
