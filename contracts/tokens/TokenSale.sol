pragma solidity ^0.4.11;

import "./Token.sol";
import "../ownership/ownable.sol";
import "../SafeMath.sol";

contract TokenSale is ownable {
    using SafeMath for uint;

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

    mapping (address => bool) refunded;

    event GoalReached(uint amountRaised);
    event SoftCapReached(uint softCap);
    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
    event AllocatedFunds(string name, address indexed holder, uint256 amount);
    event Refunded(address indexed holder, uint256 amount);

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
        uint _duration
    ) {
        hardCap = _hardCap * 1 ether;
        softCap = _softCap * 1 ether;
        price = _price;
        purchaseLimit = (_purchaseLimit * 1 ether) / price;
        token = Token(_token);

        startTime = _startTime;
        endTime = _startTime + _duration * 1 hours;
    }

    function () payable {
        if (msg.value > 0)
            doPurchase(msg.sender);
    }

    function refund() external onlyAfter(endTime) {
        if (softCapReached) throw;
        if (refunded[msg.sender]) throw;

        uint balance = token.balanceOf(msg.sender);
        if (balance == 0) throw;

        uint refund = balance / price;
        if (refund > this.balance) {
            refund = this.balance;
        }

        if (!msg.sender.send(refund)) throw;
        refunded[msg.sender] = true;
        Refunded(msg.sender, refund);
    }

    function withdraw() external onlyAfter(endTime) onlyOwner {
        if (!softCapReached) throw;
        if (!beneficiary.send(collected)) throw;
    
        allocate();
        token.finishMinting();
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
        if (token.balanceOf(msg.sender) + tokens > purchaseLimit) throw;
        
        collected = collected.add(msg.value);

        token.mint(msg.sender, tokens);

        NewContribution(_owner, tokens, msg.value);

        if (collected == hardCap) {
            GoalReached(hardCap);
        }
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
