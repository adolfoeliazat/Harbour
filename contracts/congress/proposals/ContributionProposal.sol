pragma solidity ^0.4.11;

import "./Proposal.sol";

contract ContributionProposal is Proposal {

    bytes8 public token;

    uint[] public ranges = [5, 10, 15, 20];

    function proposalType() returns (ProposalType) {
        return ProposalType.CONTRIBUTION;
    }
}
