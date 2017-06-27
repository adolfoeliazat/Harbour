pragma solidity ^0.4.11;

import "./Proposal.sol";

contract DaoChangeProposal is Proposal {

    struct Change {
        bytes32 name;
        uint value;
    }

    Change public change;

    function proposalType() returns (ProposalType) {
        return ProposalType.DAO_CHANGE;
    }

    function voteRangeEnabled() returns (bool) {
        return false;
    }

    function isValidVoteRange(uint8 _range) returns (bool) {
        return false;
    }

    function getChange() public returns (bytes32 name, uint value) {
        return (change.name, change.value);
    }
}
