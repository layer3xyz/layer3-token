// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
import {Layer3} from "../src/Layer3.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract DeployProxy is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external view {
        bytes memory deployCode = getCode();
        console.logBytes(deployCode);
    }

    function getCode() public view returns (bytes memory) {
        address impl = 0x11977cdFEE8E8b4dAF9365513f1342366436CA6b;
        address foundation = 0x97FBE916a7d21f70D65516FBDeF87122A881e54A;

        // intialize the implementation contract
        bytes memory data = abi.encodeWithSignature("initialize(address)", foundation);
        bytes memory args = abi.encode(impl, data);

        // constructor(address implementation, bytes memory _data)
        bytes memory bytecode = abi.encodePacked(vm.getCode("ERC1967Proxy.sol:ERC1967Proxy"), args);
        return bytecode;
    }

    function deployProxy(address _admin) public returns (address) {
        vm.startBroadcast(_admin);
        address proxy = Upgrades.deployUUPSProxy("Layer3.sol", abi.encodeCall(Layer3.initialize, (_admin)));
        vm.stopBroadcast();
        return address(proxy);
    }
}
