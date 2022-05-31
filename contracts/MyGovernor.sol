// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/governance/Governor.sol";
import "@openzeppelin/contracts@4.6.0/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts@4.6.0/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts@4.6.0/governance/extensions/GovernorVotes.sol";

contract MyGovernor is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes {
    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorSettings(1 /* 1 block */, 45818 /* 1 week */, 100e18)
        GovernorVotes(_token)
    {}

    function quorum(uint256 blockNumber) public pure override returns (uint256) {
        return 50000e18;
    }

    // The following functions are overrides required by Solidity.

    function votingDelay()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }
}

