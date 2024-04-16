//
//  MissingPointsViewModel.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-04-08.
//

import Foundation

class MissingPointsViewModel: ObservableObject {
    @Published var event: String = ""
    @Published var eventHistory: [String] = []
    @Published var userProfile: Profile?
    
    func getProfile() {
        APIService.getProfile { profile, error in
            if let profile = profile {
                self.userProfile = profile
            } else if let error = error {
                print("Error when retrieving Profile Points Error: \(error)")
            }
        }
    }
    
    func getEventHistory() {
        APIService.getEventHistory { events, error in
            if let events = events {
                for event in events {
                    self.eventHistory.append(event.name)
                }
            }
        }
    }
    
}
