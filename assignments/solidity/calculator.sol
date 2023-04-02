//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Calculator {
		
    function add(int256 a, int256 b) public pure returns (int256) {
        return a + b;    
    }

    function subtract(int256 a, int256 b) public pure returns (int256) {
        require(a > b, "a should be larger than b to subtract");
        return a - b;    
    }

    function multiply(int256 a, int256 b) public pure returns (int256) {
        return a * b;    
    }

    function divide(int256 a, int256 b) public pure returns (int256) {
        require(b != 0, "b should not be zero");
        return a/b;    
    }

    function modulo(int256 a, int256 b) public pure returns (int256) {
        require(b != 0, "b should not be zero");
        return a%b;    
    }

}