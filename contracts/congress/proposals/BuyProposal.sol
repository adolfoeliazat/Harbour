pragma solidity ^0.4.11;

import "./ExchangeProposal.sol";

contract BuyProposal is ExchangeProposal {

    address public token;

    uint[] public ranges = [2, 4, 6, 8, 10];

    function proposalType() returns (ProposalType) {
        return ProposalType.BUY;
    }
}
