// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ERC20Stakeable is ERC20, ERC20Burnable, ReentrancyGuard {
    struct Staker {
        uint256 deposited;
        uint256 timeOfLastUpdate;
        uint256 unclaimedRewards;
    }

    uint256 public rewardsPerHour; 
    uint256 public minStake = 10 * 10**decimals();
    
    mapping(address => Staker) internal stakers; // mapping for staker info.
    
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

    function deposit(uint256 _amount) external nonReentrant {
        require(_amount >= minStake, "Amount smaller than minimum deposit");
        require(balanceof(msg.sender) >= _amount, "Cannot stake more than you own");
        if(stakers[msg.sender].deposited == 0) {
            stakers[msg.sender].deposited = _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
            stakers[msg.sender].unclaimedRewards = 0;
        } else {
            uint256 rewards = calculateRewards(msg.sender);
            staerks[msg.sender].unclaimedRewards += rewards;
            stakers[msg.sender].deposited += _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        }
        _burn(msg.sender, _amount);
    }

    function claimRewards() external nonReentrant {
        uint256 rewards = calculateRewards(msg.sender) + stakers[msg.sender].unclaimedRewards;
        require(rewards > 0, "No reward to claim");
        stakers[msg.sender].unclaimedRewards = 0;
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        _mint(msg.sender, rewards);
    }

    function withdraw(uint256 _amount) external nonReentrant {
        require(stakers[msg.sender].deposited >= amount, "Cannot withdraw more than deposit");
        uint256 _rewards = calculateRewards(msg.sender);
        stakers[msg.sender].deposited -= amount;
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        _mint(msg.sender, _amount);
    }

    function withdrawAll() external nonReentrant {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        uint256 _rewards = calculateRewards(msg.sender) +
            stakers[msg.sender].unclaimedRewards;
        uint256 _deposit = stakers[msg.sender].deposited;
        stakers[msg.sender].deposited = 0;
        stakers[msg.sender].timeOfLastUpdate = 0;
        uint256 _amount = _rewards + _deposit;
        _mint(msg.sender, _amount);
    }

    function getDepositInfo(address _user)
        public
        view
        returns (uint256 _stake, uint256 _rewards)
    {
        _stake = stakers[_user].deposited;
        _rewards =
            calculateRewards(_user) +
            stakers[msg.sender].unclaimedRewards;
        return (_stake, _rewards);
    }

    function calculateRewards(address _staker)
        internal
        view
        returns (uint256 rewards)
    {
        return (((((block.timestamp - stakers[_staker].timeOfLastUpdate) *
            stakers[_staker].deposited) * rewardsPerHour) / 3600) / 10000000);
    }
}
