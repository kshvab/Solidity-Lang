

/*
fallback is a function that does not take any arguments and does not return anything.

It is executed either when

    a function that does not exist is called or
    Ether is sent directly to a contract but receive() does not exist or msg.data is not empty

fallback has a 2300 gas limit when called by transfer or send.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Fallback {
    event Log(uint gas);

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log(gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

//***************  How to send Ether? *********************//

/*

You can send Ether to other contracts by

    transfer (2300 gas, throws error)
    send (2300 gas, returns bool)
    call (forward all gas or set gas, returns bool)

How to receive Ether?

A contract receiving Ether must have at least one of the functions below

    receive() external payable
    fallback() external payable

receive() is called if msg.data is empty, otherwise fallback() is called.
Which method should you use?

call in combination with re-entrancy guard is the recommended method to use after December 2019.

Guard against re-entrancy by

    making all state changes before calling other contracts
    using re-entrancy guard modifier
*/



contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

