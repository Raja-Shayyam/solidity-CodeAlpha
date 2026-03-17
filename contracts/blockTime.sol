// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoLocker {
    
    // Structure to store each deposit
    struct Deposit {
        uint256 amount;          // Amount deposited
        uint256 unlockTime;      // When they can withdraw
        bool withdrawn;          // Has it been withdrawn?
    }
    
    // Mapping: user address => array of their deposits
    mapping(address => Deposit[]) public userDeposits;
    
    // Events for tracking
    event Deposited(address indexed user, uint256 amount, uint256 unlockTime, uint256 depositIndex);
    event Withdrawn(address indexed user, uint256 amount, uint256 depositIndex);
    
    /**
     * @dev Deposit Ether with a lock-in period
     * @param _lockDuration Time in seconds to lock the funds
     */
    function deposit(uint256 _lockDuration) external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        require(_lockDuration > 0, "Lock duration must be greater than 0");
        
        // Calculate unlock time
        uint256 unlockTime = block.timestamp + _lockDuration;
        
        // Create new deposit
        Deposit memory newDeposit = Deposit({
            amount: msg.value,
            unlockTime: unlockTime,
            withdrawn: false
        });
        
        // Add to user's deposits
        userDeposits[msg.sender].push(newDeposit);
        
        // Emit event
        emit Deposited(msg.sender, msg.value, unlockTime, userDeposits[msg.sender].length - 1);
    }
    
    /**
     * @dev Withdraw a specific deposit
     * @param _depositIndex Index of the deposit to withdraw
     */
    function withdraw(uint256 _depositIndex) external {
        // Get user's deposits
        Deposit[] storage deposits = userDeposits[msg.sender];
        
        // Validate deposit index
        require(_depositIndex < deposits.length, "Invalid deposit index");
        
        Deposit storage userDeposit = deposits[_depositIndex];
        
        // Check if already withdrawn
        require(!userDeposit.withdrawn, "Already withdrawn");
        
        // Check if lock time has passed
        require(block.timestamp >= userDeposit.unlockTime, "Funds are still locked");
        
        // Mark as withdrawn
        userDeposit.withdrawn = true;
        
        uint256 amount = userDeposit.amount;
        
        // Transfer funds back to user
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawn(msg.sender, amount, _depositIndex);
    }
    
    /**
     * @dev Get all deposits for a user
     */
    function getUserDeposits(address _user) external view returns (Deposit[] memory) {
        return userDeposits[_user];
    }
    
    /**
     * @dev Get total number of deposits for a user
     */
    function getUserDepositCount(address _user) external view returns (uint256) {
        return userDeposits[_user].length;
    }
    
    /**
     * @dev Check if a specific deposit is unlocked
     */
    function isUnlocked(address _user, uint256 _depositIndex) external view returns (bool) {
        require(_depositIndex < userDeposits[_user].length, "Invalid deposit index");
        return block.timestamp >= userDeposits[_user][_depositIndex].unlockTime;
    }
    
    /**
     * @dev Get time remaining until unlock (in seconds)
     */
    function getTimeUntilUnlock(address _user, uint256 _depositIndex) external view returns (uint256) {
        require(_depositIndex < userDeposits[_user].length, "Invalid deposit index");
        
        uint256 unlockTime = userDeposits[_user][_depositIndex].unlockTime;
        
        if (block.timestamp >= unlockTime) {
            return 0; // Already unlocked
        }
        
        return unlockTime - block.timestamp;
    }
    
    // Get contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}