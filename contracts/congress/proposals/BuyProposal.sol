pragma solidity ^0.4.11;

import "./ExchangeProposal.sol";

contract BuyProposal is ExchangeProposal {

    address public token;

    uint[] public ranges = [5, 10, 15, 20];

    function proposalType() returns (ProposalType) {
        return ProposalType.BUY;
    }
}
