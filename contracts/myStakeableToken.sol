// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC20Stakeable.sol";
// import openzeppelin ownable.sol

contract myStakeableToken is ERC20Stakeable, Ownable {
    constructor(string memory _name, string memory _symbol) {
        ERC20Stakeable(_name, _symbol)
        {
            _mint(msg.sender, 1000000 * 10**decimals());
        }
    }

    function setMinStake(uint256 _minStake) public onlyOwner {
        minStake = _minStake;
    }

    // implement other staking utility function needed.
}

