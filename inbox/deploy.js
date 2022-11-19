// deploy code will go here

// This file will deploy the compiled code to an Ethereum network

// Here we want to use one of the main test networks (not a ganache local test network)
// To do this we must create our own provider
const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');


// To create our own provider we need to pass in our account mnemonic and node in the Eth network we want to deploy our contract to
// To deploy to a node, we have a few options:
//      1. Make our own computer a node and connect it to the Eth network (not recommended: takes a lot of time and resources)
//      2. Infura (free and easy to use; Infura is a service that hosts a node on its own machine and allows us to connect to it)
const provider = new HDWalletProvider(
    'tuna jungle emerge film kit reform expose table high inflict borrow humor',
    'https://goerli.infura.io/v3/6e9bcda8ea744de6b13ed00989008d8b'
);

const web3 = new Web3(provider);


// We need to call the deploy function to actually deploy the contract
// This code looks very similar to the code in the test file (Inbox.test.js - Look here for more comments)
const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({ data: bytecode, arguments: ['Hi there!'] })
        .send({ gas: '1000000', from: accounts[0] });

    console.log('Contract deployed to', result.options.address);
};

deploy();