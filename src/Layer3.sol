// SPDX-License-Identifier: Apache-2.0

/*
.____                             ________
|    |   _____  ___.__. __________\_____  \
|    |   \__  \<   |  |/ __ \_  __ \_(__  <
|    |___ / __ \\___  \  ___/|  | \/       \
|_______ (____  / ____|\___  >__| /______  /
        \/    \/\/         \/            \/
*/

pragma solidity 0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PermitUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Layer3 is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PermitUpgradeable,
    Ownable2StepUpgradeable,
    UUPSUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address foundation) external initializer {
        __ERC20_init("Layer3", "L3");
        __ERC20Burnable_init();
        __ERC20Permit_init("Layer3");

        __Ownable_init(foundation);
        __Ownable2Step_init();
        __UUPSUpgradeable_init();

        uint256 supply = 3_333_333_333 * (10 ** uint256(decimals()));
        _mint(foundation, supply);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
