pragma solidity ^0.4.11;

import "../ownership/ownable.sol";

contract Mintable is ownable {
    
    bool public mintFinished = false;

    event Mint(address indexed to, uint value);
    event MintFinished();

    modifier canMint {
        if (mintFinished) throw;
        _;
    }

    function mint(address _to, uint _amount) onlyOwner canMint returns (bool);
    function finishMinting() onlyOwner returns (bool);
}
