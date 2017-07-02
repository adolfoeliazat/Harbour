pragma solidity ^0.4.11;

import "./Executor.sol";
import "../../Configuration.sol";
import "../proposals/Proposal.sol";
import "../proposals/DaoChangeProposal.sol";
import "../../ownership/ownable.sol";

contract DaoChangeExecutor is ownable {

    Configuration public configuration;

    function DaoChangeExecutor(Configuration _configuration) {
        configuration = _configuration;
    }

    function proposalType() returns (Proposal.ProposalType) {
        return Proposal.ProposalType.DAO_CHANGE;
    }

    function execute(Proposal _proposal) onlyOwner returns (bool) {
        DaoChangeProposal proposal = DaoChangeProposal(_proposal);
        var (name, value) = proposal.getChange();
        configuration.set(name, value);
    }

    function destroy() onlyOwner {
        selfdestruct(owner);
    }
}
