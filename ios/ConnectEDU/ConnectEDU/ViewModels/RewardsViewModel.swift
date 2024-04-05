//
//  RewardsViewModel.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-26.
//

import Foundation

class RewardsViewModel: ObservableObject {
    @Published var rewards: [RewardListObject] = .init()
    @Published var userProfile: Profile?
        
    
    func getRewards() {
        APIService.getRewards { rewards, error in
            if let rewards = rewards {
                self.rewards = rewards
            } else if let error = error {
                print("Error when retrieving rewards Error: \(error)")
            }
        }
    }
    
    func getProfile() {
        APIService.getProfile { profile, error in
            if let profile = profile {
                self.userProfile = profile
            } else if let error = error {
                print("Error when retrieving Profile Points Error: \(error)")
            }
        }
    }
}
