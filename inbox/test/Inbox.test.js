// contract test code will go here

const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const { interface, bytecode } = require('../compile');

const provider = ganache.provider(); // instructs what network we want to connect to and contains info about different accounts
const web3 = new Web3(provider); //portal to the Ethereum network
// allows us to interact with the Ethereum network

// HOW TO DO MOCHA TESTING: 
// class Car {
//     park() {
//         return 'stopped';
//     }

//     drive() {
//         return 'vroom';
//     }
// }


// describe('Car', () => { // used to describe a group of tests
//     const car = new Car();
//     it('can park', () => {
//         assert(car.park(), 'stopped')
//     })

//     it('can drive', () => {
//         assert(car.drive(), 'vroom')
//     })
// })

let accounts;
let inbox;

beforeEach(async () => {
    // Get a list of all accounts
    accounts = await web3.eth.getAccounts();
    // Use one of those accounts to deploy
    // the contract

    // We deploy an ethereum contract and pass in the ABI into the contract constructor
    // We then deploy the contract and pass in the bytecode and any arguments that the contract constructor function requires
    // We then send the transaction to the network and wait for the transaction to be mined
    inbox = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({ data: bytecode, arguments: ['Hi there!'] })
        .send({ from: accounts[0], gas: '1000000' })

    // our 'inbox' variable is now a javascript representation of our contract

    // Remember: deploy() just creates a local copy of the contract, it does not deploy it to the network
    // We need to call the method .send() to actually deploy the contract to the network
});

describe('Inbox', () => {
    it('deploys a contract', () => {
        console.log(inbox);
        assert.ok(inbox.options.address); // is the address defined?
    });

    it('has a default message', async () => {
        // 'inbox.methods': is a reference to all the methods that exist in the contract
        // 'inbox.methods.message()': is a reference to the message() method in the contract (pass in arguments here)
        // 'inbox.methods.message().call()': call message() method in the contract
        const message = await inbox.methods.message().call();
        assert.equal(message, 'Hi there!');
    });

    it('can change the message', async () => {
        await inbox.methods.setMessage('Bye Now!').send({ from: accounts[0] });
        const message = await inbox.methods.message().call();
        assert.equal(message, 'Bye Now!');
    })
});