pragma solidity ^0.4.11;

import "../Configuration.sol";
import "../ownership/ownable.sol";
import "./proposals/Proposal.sol";
import "./executors/Executor.sol";

contract Congress is ownable {

    Proposal[] public proposals;
    Configuration public configuration;

    mapping (uint8 => Executor) executors;
    mapping (uint => bool) executed;

    function Congress(Configuration _configuration) {
        configuration = _configuration;
    }

    function setExecutor(Executor _executor) onlyOwner {
        if (!_executor.isOwner(this)) throw;
        executors[uint8(_executor.proposalType())] = _executor;
    }

    function executeProposal(uint _proposal) external {
        Proposal proposal = proposals[_proposal];

        if (executed[_proposal]) throw;
        if (proposal.deadline() > now) throw;
        if (proposal.getVoterQuorum() < configuration.get("minimumQuorum")) throw;
        if (!proposal.didPass()) throw;

        Executor executor = executors[uint8(proposal.proposalType())];
        if (!executor.execute(proposal)) throw;

        executed[_proposal] = true;
    }
}
