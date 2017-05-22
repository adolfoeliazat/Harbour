pragma solidity ^0.4.11;

import "./Token.sol";
import "./../misc/ownable.sol";

contract TokenSale is ownable {

    struct Allocation {
        string name;
        address beneficiary;
        uint amount;
    }

    Token public token;
    Allocation[] public allocations;

    address public beneficiary;

    uint public hardCap;
    uint public softCap;
    uint public collected;
    uint public price;
    uint public purchaseLimit;

    uint public startTime;
    uint public endTime;

    bool public softCapReached = false;
    bool public allocated = false;

    mapping (address => uint) purchases;

    event GoalReached(uint amountRaised);
    event SoftCapReached(uint softCap);
    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
    event AllocatedFunds(string name, address indexed holder, uint256 amount);

    modifier onlyAfter(uint time) {
        if (now < startTime) throw;
        _;
    }

    modifier onlyBefore(uint time) {
        if (now < time) throw;
        _;
    }

    function TokenSale(
        uint _hardCap, 
        uint _softCap,
        address _token, 
        uint _price, 
        uint _purchaseLimit,
        uint _startTime,
        uint _duration
    ) {
        hardCap = _hardCap * 1 ether;
        softCap = _softCap * 1 ether;
        price = _price;
        purchaseLimit = _purchaseLimit * 1 ether;
        token = Token(_token);

        startTime = _startTime;
        endTime = _startTime + _duration * 1 hours;
    }

    function () payable {
        doPurchase(msg.sender);
    }

    function allocate() onlyAfter(endTime) onlyOwner {
        if (allocated) throw;

        for (uint i = 0; i < allocations.length; i++) {
            token.transfer(allocations[i].beneficiary, allocations[i].amount);
            AllocatedFunds(allocations[i].name, allocations[i].beneficiary, allocations[i].amount);
        }

        allocated = true;
    }

    function withdraw() onlyAfter(endTime) onlyOwner {
        if (collected >= softCap) {
            beneficiary.send(collected);
            return;
        }

        // @todo if not run refunds
    }

    function addAllocation(string name, address beneficiary, uint amount) onlyOwner {
        allocations[allocations.length] = Allocation(name, beneficiary, amount);
    }

    function doPurchase(address _owner) onlyAfter(startTime) onlyBefore(endTime) private {
        if (collected + msg.value > hardCap) throw;

        if (!softCapReached && collected < softCap && collected + msg.value >= softCap) {
            softCapReached = true;
            SoftCapReached(softCap);
        }

        uint tokens = msg.value * price;

        if (purchases[_owner] + msg.value > purchaseLimit) throw;

        collected += msg.value;
        purchases[_owner] += msg.value;

        token.transfer(msg.sender, msg.value);
        NewContribution(_owner, tokens, msg.value);
    }
}
