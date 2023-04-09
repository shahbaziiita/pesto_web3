# String Operations Smart contract

### Requirement

Implement string operations. The smart contract should allow users to:

1. Find length of a given string
2. Find character at a given index in string
3. Replace all occurrences of a character to another character in a given string

### Implementation Details:

1. Since solidity does not provide .length() function for a string, we need to first convert string into bytes 
and get the length of the bytes. This length will be the length of the input string.

2. To find character at a given index, first convert it into bytes array and then get the bytes data at 
that particular index. Also needs to check that bytes length should be greater than equal to the given index.

3. Convert input string and character to be replaced to bytes and then check if bytes are equal and then 
 change the bytes to the desired character.

### How to run?
Compile and run this code though Remix IDE. Deploy it on preferred network and call different functions to test.