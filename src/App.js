// src/App.js
import React, { useState } from 'react';
import { connectWallet, createCampaign, viewCampaign, contribute } from './utils/aptosClient';
import './App.css';

function App() {
  const [userAccount, setUserAccount] = useState(null);
  const [goalAmount, setGoalAmount] = useState('');
  const [campaignDetails, setCampaignDetails] = useState(null);
  const [contributionAmount, setContributionAmount] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // Connect wallet on button click
  const handleConnectWallet = async () => {
    try {
      setIsLoading(true);
      const account = await connectWallet();
      setUserAccount(account);
      console.log('Connected account:', account.address);
    } catch (error) {
      alert('Failed to connect wallet.');
    } finally {
      setIsLoading(false);
    }
  };

  // Handle campaign creation
  const handleCreateCampaign = async () => {
    if (!goalAmount) return;
    try {
      setIsLoading(true);
      await createCampaign(goalAmount, userAccount.address);
      alert('Campaign created successfully!');
      setGoalAmount('');
    } catch (error) {
      alert('Error creating campaign.');
    } finally {
      setIsLoading(false);
    }
  };

  // Fetch and display campaign details
  const handleViewCampaign = async () => {
    try {
      setIsLoading(true);
      const campaign = await viewCampaign(userAccount.address);
      setCampaignDetails(campaign);
    } catch (error) {
      alert('Error fetching campaign.');
    } finally {
      setIsLoading(false);
    }
  };

  // Handle contribution to campaign
  const handleContribute = async () => {
    if (!contributionAmount) return;
    try {
      setIsLoading(true);
      await contribute(userAccount.address, contributionAmount);
      alert('Contribution successful!');
      setContributionAmount('');
    } catch (error) {
      alert('Error contributing.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="app-container">
      <header className="app-header">
        <h1>Student Crowdfunding Platform</h1>
        <p>A decentralized way to raise funds for educational expenses on Aptos</p>
      </header>

      <div className="card">
        <h2>Connect Wallet</h2>
        <button 
          className="connect-btn" 
          onClick={handleConnectWallet}
          disabled={isLoading}
        >
          {isLoading ? 'Connecting...' : userAccount ? 'Wallet Connected' : 'Connect Wallet'}
        </button>

        {userAccount && (
          <div className="account-info">
            Connected: {userAccount.address}
          </div>
        )}
      </div>

      {userAccount && (
        <>
          <div className="card">
            <h2>Create Campaign</h2>
            <div className="form-group">
              <input
                type="number"
                value={goalAmount}
                onChange={(e) => setGoalAmount(e.target.value)}
                placeholder="Goal Amount (APT)"
                disabled={isLoading}
              />
            </div>
            <button 
              onClick={handleCreateCampaign}
              disabled={!goalAmount || isLoading}
            >
              {isLoading ? 'Creating...' : 'Create Campaign'}
            </button>
          </div>

          <div className="card">
            <h2>View Campaign</h2>
            <button 
              onClick={handleViewCampaign}
              disabled={isLoading}
            >
              {isLoading ? 'Loading...' : 'View Campaign'}
            </button>
            
            {campaignDetails && (
              <div className="campaign-details">
                <p>
                  <span className="label">Goal:</span>
                  <span className="value">{campaignDetails.goal_amount} APT</span>
                </p>
                <p>
                  <span className="label">Raised:</span>
                  <span className="value">{campaignDetails.current_amount} APT</span>
                </p>
                <p>
                  <span className="label">Status:</span>
                  <span className={campaignDetails.active ? "badge" : "badge inactive"}>
                    {campaignDetails.active ? 'Active' : 'Completed'}
                  </span>
                </p>
              </div>
            )}
          </div>

          <div className="card">
            <h2>Contribute to Campaign</h2>
            <div className="form-group">
              <input
                type="number"
                value={contributionAmount}
                onChange={(e) => setContributionAmount(e.target.value)}
                placeholder="Contribution Amount (APT)"
                disabled={isLoading}
              />
            </div>
            <button 
              onClick={handleContribute}
              disabled={!contributionAmount || isLoading}
            >
              {isLoading ? 'Processing...' : 'Contribute'}
            </button>
          </div>
        </>
      )}
    </div>
  );
}

export default App;
