// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console, Vm} from "forge-std/Test.sol";

import {Layer3} from "../src/Layer3.sol";
import {Layer3MockV2} from "./mock/Layer3MockV2.sol";

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
        assertEq(layer3.totalSupply(), 3_333_333_333 * 10 ** 18);
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

    function testBurn() public {
        uint256 initialBalance = layer3.balanceOf(ALICE);
        vm.prank(ALICE);
        uint256 burnAmount = 100;
        layer3.burn(burnAmount);

        assertEq(layer3.balanceOf(ALICE), initialBalance - burnAmount);
    }

    function testBurnWithAllowance() public {
        uint256 initialBalance = layer3.balanceOf(ALICE);
        uint256 burnAmount = 50;

        vm.prank(ALICE);
        layer3.approve(BOB, burnAmount);

        vm.prank(BOB);
        layer3.burnFrom(ALICE, burnAmount);

        assertEq(layer3.balanceOf(ALICE), initialBalance - burnAmount);
    }

    function testUpgrade() public {
        vm.startPrank(ALICE);
        _upgradeContract(proxyAddress);

        Layer3MockV2 v2 = Layer3MockV2(proxyAddress);
        v2.increment();

        vm.stopPrank();

        assertEq(v2.count(), 1);
    }

    function _upgradeContract(address _proxyAddress) internal {
        Upgrades.upgradeProxy(_proxyAddress, "Layer3MockV2.sol", new bytes(0));
    }
}
