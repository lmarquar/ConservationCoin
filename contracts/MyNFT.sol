// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC1363} from "@openzeppelin/contracts/token/ERC20/extensions/ERC1363.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Bridgeable} from "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Bridgeable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact service@lemarq4.de
contract ConservationCoin is
    ERC20,
    ERC20Bridgeable,
    Ownable,
    ERC1363,
    ERC20Permit
{
    address public tokenBridge;
    error Unauthorized();

    constructor(
        address tokenBridge_,
        address recipient,
        address initialOwner
    )
        ERC20("ConservationCoin", "CNSRV")
        Ownable(initialOwner)
        ERC20Permit("ConservationCoin")
    {
        require(tokenBridge_ != address(0), "Invalid tokenBridge_ address");
        tokenBridge = tokenBridge_;
        if (block.chainid == 1) {
            _mint(recipient, 1000 * 10 ** decimals());
        }
    }

    function _checkTokenBridge(address caller) internal view override {
        if (caller != tokenBridge) revert Unauthorized();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC20Bridgeable, ERC1363) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
