pragma solidity ^0.4.11;

import "./Mintable.sol";
import "../ownership/ownable.sol";
import "../SafeMath.sol";

contract TokenSale is ownable {
    using SafeMath for uint;

    struct Allocation {
        string name;
        address beneficiary;
        uint amount;
    }

    Mintable public token;
    Allocation[] public allocations;

    address public beneficiary;
    address[] public holders;

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
        if (now < time) throw;
        _;
    }

    modifier onlyBefore(uint time) {
        if (now > time) throw;
        _;
    }

    function TokenSale(
        uint _hardCap,
        uint _softCap,
        address _token,
        uint _price,
        uint _purchaseLimit,
        uint _startTime,
        uint _duration,
        address _beneficiary
    ) {
        hardCap = _hardCap * 1 ether;
        softCap = _softCap * 1 ether;
        price = _price;
        purchaseLimit = _purchaseLimit * 1 ether;
<<<<<<< HEAD
        token = Token(_token);
        beneficiary = _beneficiary;
=======
        token = Mintable(_token);
>>>>>>> development

        startTime = _startTime;
        endTime = _startTime + _duration * 1 hours;
    }

    function () payable {
        if (msg.value > 0)
            doPurchase(msg.sender);
    }

    function withdraw() onlyAfter(endTime) onlyOwner {
        if (softCapReached) {
            if (!beneficiary.send(collected)) throw;
            allocate();
            token.finishMinting();
            return;
        }

        for (uint i = 0; i < holders.length; i++) {
            address holder = holders[i];
            if (purchases[holder] == 0) continue;
            if (!holder.send(purchases[holder])) continue;
            purchases[holder] = 0;
        }
    }

    function addAllocation(string name, address beneficiary, uint amount) onlyOwner onlyBefore(startTime) {
        allocations[allocations.length] = Allocation(name, beneficiary, amount);
    }

    function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {
        if (collected.add(msg.value) > hardCap) throw;

        if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
            softCapReached = true;
            SoftCapReached(softCap);
        }

        uint tokens = msg.value * price;

        if (purchases[_owner].add(msg.value) > purchaseLimit) throw;
        if (purchases[_owner] == 0) {
            holders[holders.length] = _owner;
        }

        collected = collected.add(msg.value);
        purchases[_owner] = purchases[_owner].add(msg.value);

        token.mint(msg.sender, tokens);
        NewContribution(_owner, tokens, msg.value);
    }

    function allocate() private onlyAfter(endTime) {
        if (allocated) throw;

        for (uint i = 0; i < allocations.length; i++) {
            token.mint(allocations[i].beneficiary, allocations[i].amount);
            AllocatedFunds(allocations[i].name, allocations[i].beneficiary, allocations[i].amount);
        }

        allocated = true;
    }
}
