// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Coinflip.sol";
import "@forge-std/Script.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CoinflipScript is Script {
    using SafeMath for uint256;
    CoinFlip public coinflipContract;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    function setUp() public {
        coinflipContract = CoinFlip(payable(vm.envAddress("COINFLIP_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;
        if(side) {
            coinflipContract.flip(true);
        }
        else {
            coinflipContract.flip(false);
        }
        console.log("Consecutive Wins: ", coinflipContract.consecutiveWins());
        vm.stopBroadcast();
    }
}