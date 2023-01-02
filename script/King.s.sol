// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import {King} from "../src/King.sol";
contract KingScript is Script {
    King public kingContract;

    function setUp() public {
        kingContract = King(payable(vm.envAddress("KING_CONTRACT")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        vm.stopBroadcast();
    }
}
