// // // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.0;

// import {Recovery, SimpleToken} from "../src/Recovery.sol";
// import "@forge-std/Test.sol";

// contract RecoveryTest is Test {
//     Recovery public recoveryContract;
//     address public attacker;
//     address public creator;

//     function setup() public {
//         recoveryContract = new Recovery();
//         attacker = vm.addr(1);
//         creator = vm.addr(2);
//         vm.deal(attacker, 1 ether);
//         vm.deal(creator, 1 ether);
//     }

//     function testExploit() public {
//         vm.startPrank(creator);
//         recoveryContract.generateToken("Hak", 0.001 ether);
//         vm.stopPrank();

//         assertEq(address(SimpleToken).balances(creator), 0.001 ether);
//         vm.startPrank(attacker);
//         SimpleToken.destroy(attacker);
//         vm.stopPrank();
//     }
// }