// compile code will go here

// This file will compile each of the Solidity files in the contracts folder

const path = require('path');
const fs = require('fs');
const solc = require('solc');


const inboxPath = path.resolve(__dirname, 'contracts', 'Inbox.sol');
const source = fs.readFileSync(inboxPath, 'utf8');

// solc is the solidity compiler:
// It compiles solidity code into 2 properties:
// 1. bytecode: the actual code that gets deployed to the blockchain
// 2. interface: the ABI (Application Binary Interface) which is a JSON representation of all the methods and properties that exist in the contract
module.exports = solc.compile(source, 1).contracts[':Inbox'];