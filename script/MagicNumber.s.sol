// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../src/MagicNumber.sol";
import "@forge-std/Script.sol";

contract Factory {
    event Log(address addr);

    // Deploys a contract that always returns 42
    function deploy() external returns (address) {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address addr;
        assembly {
            // create(value, offset, size)
            addr := create(0, add(bytecode, 0x20), 0x13)
        }
        require(addr != address(0));

        return addr;
    }
}


contract MagicNumScript is Script {
    MagicNum public magicnumContract;

    function setUp() public {
        magicnumContract = MagicNum(payable(vm.envAddress("MAGICNUM_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Factory factory = new Factory();
        address attack = factory.deploy();
        magicnumContract.setSolver(attack);
        vm.stopBroadcast();
    }
}

// Reference: https://www.youtube.com/watch?v=0qQUhsPafJc&ab_channel=SmartContractProgrammer