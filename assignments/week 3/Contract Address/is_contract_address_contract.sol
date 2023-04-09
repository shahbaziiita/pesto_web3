// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract check_for_contract_address {
    function isContract(address _addr) public view returns (bool isContractAddress){
    uint32 size;
    assembly {
        size := extcodesize(_addr)
    }
    return (size > 0);
    }
}
