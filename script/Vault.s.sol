// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
contract VaultScript is Script {
    Vault public vaultContract;

    function setUp() public {
        vaultContract = Vault(payable(vm.envAddress("VAULT_CONTRACT")));    
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        bytes32 password = vm.load(address(vaultContract), bytes32(uint256(1)));
        vaultContract.unlock(password);
        vm.stopBroadcast();
    }
}
