// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Test.sol";
import {King} from "../src/King.sol";

contract Attack {
    constructor() {

    }

    receive() external payable {
        
    }
}
contract KingTest is Test {
    King public kingContract;
    address public attacker;

    function setUp() public {
        attacker = vm.addr(1);
        kingContract =  new King();    
    }
    function testExploit() public {
        vm.startPrank(attacker);
        
        vm.stopPrank();
    }
}
