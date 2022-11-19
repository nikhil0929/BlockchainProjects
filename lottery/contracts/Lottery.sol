pragma solidity ^0.8.13;

/*
What is the difference between Storage, Memory, and Calldata?
- Storage: Persistent data that is stored on the blockchain
- Memory: Temporary data that is erased after the transaction is completed
- Calldata: Function arguments
*/

contract Lottery {
    // Rememeber: Using 'public' or 'private' enforces NO security over the data in the contract
    // Much more for other developers to see if they can access this variable
    //  - When we create a React app, we want to be able to access this variable to display on webpage
    address public manager;
    address[] public players;

    constructor() {
        // Set manager field to whoever creates this contract
        manager = msg.sender;
    }

    function enterLottery() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        // Generate a random number based on the block hash and the current time
        //  - This is not a secure way to generate a random number
        //  - This is just for demonstration purposes
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);
        players = new address[](0); // reset players array and create a new one with an initial length of 0
    }

    // Modifier functions are used to reduce code duplication
    // Basically like a "Do this before running the function"
    modifier restricted() {
        require(msg.sender == manager); // Only the manager can pick the winner
        _;
    }
}
