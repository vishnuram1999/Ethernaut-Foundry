// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {MagicNum} from "../src/MagicNumber.sol";
import "@forge-std/Test.sol";

pragma solidity ^0.8.17;

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

interface IContract {
    function whatIsTheMeaningOfLife() external view returns (uint);
}


contract MagicNumTest is Test {
    MagicNum public magicnum;
    address public attacker;

    function setup() public {
        magicnum = new MagicNum();
        attacker = vm.addr(1);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        Factory factory = new Factory();
        address attack = factory.deploy();
        IContract icontract = IContract(address(attack));
        vm.stopPrank();

        assert(icontract.whatIsTheMeaningOfLife() == 42);
    }
}