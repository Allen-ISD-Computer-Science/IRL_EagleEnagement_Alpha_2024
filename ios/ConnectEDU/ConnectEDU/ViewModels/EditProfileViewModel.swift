//
//  EditProfileViewModel.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-04-08.
//

import Foundation

class EditProfileViewModel : ObservableObject {
    @Published var userProfile: Profile?
    @Published var name: String = ""
    @Published var studentID: Int = 0
    @Published var grade: Int = 0
    @Published var house: Int = 0
    
    
    func getProfile() {
        APIService.getProfile { profile, error in
            if let profile = profile {
                self.userProfile = profile
                self.name = profile.name
                self.studentID = profile.studentID
                self.grade = profile.grade
                self.house = profile.house
            } else if let error = error {
                print("Error when retrieving Profile Points Error: \(error)")
            }
        }
    }
}
