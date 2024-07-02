// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Layer3} from "../../src/Layer3.sol";

/// this is a mock contract to test the upgradeability
/// @custom:oz-upgrades-from Layer3
contract Layer3MockV2 is Layer3 {
    uint256 public count;

    function increment() public {
        count += 1;
    }
}
