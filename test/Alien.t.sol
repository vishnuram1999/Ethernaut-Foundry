// // SPDX-License-Identifier: MIT
// pragma solidity ^0.5.0;

// import "../src/Alien.sol";
// import "@forge-std/Test.sol";

// contract AlienCodexTest is Test {

//     AlienCodex public alienContract;
//     address public attacker;
//     function setUp() public {
//         alienContract = new AlienCodex();
//         attacker = vm.addr(1);
//         vm.deal(attacker, 1 ether);
//     }

//     function testExploit() public {
//         vm.startPrank(attacker);
//         bytes32 value = vm.load(address(alienContract), bytes32(uint256(0)));
//         assertEq(value, false);
//         vm.stopPrank();

//         assertEq(alienContract.owner(), attacker);
//     }
// }
