// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;
// import "../src/Token.sol";
// import "@forge-std/Script.sol";

// contract TokenScript is Script {

//     Token public tokenContract;

//     function setUp() public {
//         tokenContract = Token(payable(vm.envAddress("TOKEN_CONTRACT")));
//     }

//     function run() public {
//         vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

//         vm.stopBroadcast();
//     }

// }