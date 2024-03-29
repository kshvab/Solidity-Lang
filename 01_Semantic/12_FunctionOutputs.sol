// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;


// Return multiple outputs
// Named outputs
// Destructuring Assignments

contract FunctionOutputs {

    function returnMany() public pure returns (uint, bool) {
        return (1, true);
    }

    function named() public pure returns (uint x, bool b) {
        return (1, true);
    }

    function asigned() public pure returns (uint x, bool b) {
        x = 1;
        b = true;
    }

    function destructingAssignments() public pure {
        //(uint x, bool b) = returnMany();
        // or
        (, bool _b) = returnMany();

    }

}

