pragma solidity ^0.4.17;

// linter warnings (red underline) about pragma version can igonored!

// contract code will go here

contract Inbox {
    /*
    Different types of variables:
    - string: sequence of characters
    - bool: boolean
    - uint: unsigned integer; positive or zero
    - int: signed integer; positive, negative or zero
    - fixed/ufixed: fixed point number (decimal)
    - address: Ethereum address; has methods for sending Ether and calling contracts
    */
    string public message;

    function Inbox(string initialMessage) public {
        message = initialMessage;
    }

    function setMessage(string newMessage) public {
        message = newMessage;
    }
}
