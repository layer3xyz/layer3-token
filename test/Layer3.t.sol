// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console, Vm} from "forge-std/Test.sol";

import {Layer3} from "../src/Layer3.sol";
import {Layer3V2} from "./Layer3V2.sol";

import {DeployProxy} from "../script/Deploy.s.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract Layer3Test is Test {
    Layer3 public layer3;

    uint256 internal ownerPrivateKey;
    address internal ownerPubKey;

    DeployProxy public deployer;

    // Test Users
    address public ALICE = makeAddr("alice");
    address public BOB = makeAddr("bob");

    address public adminAddress;
    uint256 internal adminPrivateKey;

    address public proxyAddress;

    function setUp() public {
        deployer = new DeployProxy();
        proxyAddress = deployer.deployProxy(ALICE);
        layer3 = Layer3(payable(proxyAddress));
    }

    function testInitialSupply() public view {
        assertEq(layer3.totalSupply(), 3_333_333_333);
    }

    function testOwner() public view {
        assertEq(layer3.owner(), ALICE);
    }

    function testChangeOwner() public {
        vm.prank(ALICE);
        layer3.transferOwnership(BOB);

        vm.prank(BOB);
        layer3.acceptOwnership();
        assertEq(layer3.owner(), BOB);
    }

    function testTransfer() public {
        vm.prank(ALICE);
        layer3.transfer(BOB, 100);
        assertEq(layer3.balanceOf(BOB), 100);
    }

    function testUpgrade() public {
        vm.startPrank(ALICE);
        _upgradeCube(proxyAddress);

        Layer3V2 v2 = Layer3V2(proxyAddress);
        v2.increment();

        vm.stopPrank();

        assertEq(v2.count(), 1);
    }

    function _upgradeCube(address _proxyAddress) internal {
        Upgrades.upgradeProxy(_proxyAddress, "Layer3V2.sol", new bytes(0));
    }
}
