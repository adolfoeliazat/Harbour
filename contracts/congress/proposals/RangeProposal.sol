pragma solidity ^0.4.11;

import "./Proposal.sol";

contract RangeProposal is Proposal {

    uint[] public ranges;

    function voteRangeEnabled() returns (bool) {
        return true;
    }

    function isValidVoteRange(uint8 _range) returns (bool) {
        for (uint i = 0; i < ranges.length; i++) {
            if (ranges[i] == _range) {
                return true;
            }
        }

        return false;
    }

    function getWinningRange() returns (uint) {
        uint[] memory results;
        for (uint i = 0; i < votes.length; i++) {
            Vote vote = votes[i];
            if (Choice(vote.choice) == Choice.NO) {
                continue;
            }

            results[vote.range] = token.balanceOf(vote.voter);
        }

        uint winner = 0;
        for (uint key = 0; key < ranges.length; key++) {
            if (key == 0) {
                winner = ranges[key];
                continue;
            }

            var range = ranges[key];
            if (results[range] > results[winner]) {
                winner = range;
            }
        }

        return winner;
    }
}
