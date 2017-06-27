pragma solidity ^0.4.11;

import "../proposals/Proposal.sol";
import "../../ownership/ownable.sol";

contract Executor is ownable {

    function proposalType() returns (Proposal.ProposalType);

    function execute(Proposal _proposal) onlyOwner returns (bool);

    function destroy() onlyOwner {
        selfdestruct(owner);
    }
}
