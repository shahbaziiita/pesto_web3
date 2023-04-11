// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title StringOperations
 * Contract to perform String Operations
 *
 * 1. Find the length of the given string
 * 2. Find the index of the first occurrence of the given character
 * 3. Replace every occurrence of the given character
 *
 */

 /**
 Assumptions: Assume that all the characters in the string are ASCII characters and do not include Unicode characters
 */

/// @author Shahbaz Khan
/// @title A simple String Operations example
contract StringOperations {

    /// Return the length of string.
    /// @dev convert to bytes and return length of string
    /// @return the length
    function findLength(string memory s) public pure returns (uint256) {
        return bytes(s).length;
    }

    /// Return the character at index i.
    /// @dev convert to bytes and return bytes at that index
    /// @return the bytes
    function findAtIndex(string calldata s, uint256 i) public pure returns (bytes1) {
        require(bytes(s).length-1 >= i, "Out of index error");
        return bytes(s)[i];
    }


    /// Return the string after replace all occurence of x to y
    /// @dev convert to bytes and then do the transformation
    /// @return the string
    function replaceAllOccurence(string calldata s, string calldata x, string calldata y ) public pure returns(string memory) {
        bytes memory _stringBytes = bytes(s);
        bytes1 xBytes = bytes(x)[0];
        bytes1 yBytes = bytes(y)[0];

        for(uint i; i < _stringBytes.length; i++) {

            if(_stringBytes[i] == xBytes) {
                _stringBytes[i] = yBytes;
            }
        }
        return string(_stringBytes);
    }
}
