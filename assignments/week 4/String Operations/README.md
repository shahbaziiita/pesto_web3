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

### Why do we convert to bytes before string operations? 

Since solidity does not provide inbuilt functions for string such as length, concat. we need to first convert this 
into bytes and then so the string operations. 

### Length of a string

if string s = "Solidity", then

```
bytes(s).length
```

will gives 8 i.e., length of a given string


By default bytes data strcuture will take 32 bytes.
if we write, 

```
bytes memory a = bytes("hello");
```

This will store this string to 32 bytes memory.  

We can change this to different byte declaration like

```
bytes8 memory a = bytes("hello");
```

This will store this string to 8 bytes memory. 




### How to run?
Compile and run this code though Remix IDE. Deploy it on preferred network and call different functions to test.