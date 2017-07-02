pragma solidity ^0.4.11;

import "../../tokens/ERC20.sol";

contract Proposal {

    enum ProposalType { DAO_CHANGE, BUY, CONTRIBUTION }
    enum Choice { YES, NO }

    struct Vote {
        address voter;
        uint8 choice;
        uint8 range;
    }

    Vote[] votes;
    ERC20 public token;
    address public creator;
    uint public deadline;

    mapping (address => bool) voted;

    event Voted(address indexed voter, uint8 choice);

    function proposalType() returns (ProposalType);
    function voteRangeEnabled() returns (bool);
    function isValidVoteRange(uint8 _range) returns (bool);

    function deadline() constant returns (uint) {
        return deadline;
    }

    function vote(Choice _choice, uint8 _range) external {
        if (voted[msg.sender]) throw;

        // ew
        uint8 _voteRange = 0;
        if (voteRangeEnabled()) {
            if (!isValidVoteRange(_range)) throw;
            _voteRange = _range;
        }

        votes.push(Vote(msg.sender, uint8(_choice), _voteRange));
        voted[msg.sender] = true;

        Voted(msg.sender, uint8(_choice));
    }

    function didPass() returns (bool) {
        uint yes = 0;
        uint no = 0;

        for (uint i = 0; i < votes.length; i++) {
            Vote vote = votes[i];
            uint voteBalance = token.balanceOf(vote.voter);

            if (Choice(vote.choice) == Choice.YES) {
                yes += voteBalance;
                continue;
            }

            no += voteBalance;
        }

        return yes > no;
    }

    function getVoterQuorum() returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < votes.length; i++) {
            sum += token.balanceOf(votes[i].voter);
        }

        return (sum / token.totalSupply()) * 100;
    }
}
