//
//  ProfileViewModel.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-26.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userProfile: Profile = Profile()
    
    init() {
        getProfile()
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
