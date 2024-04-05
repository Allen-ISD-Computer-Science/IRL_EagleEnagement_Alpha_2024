//
//  Profile.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-07.
//

import Foundation

struct Profile: Codable {
    let name: String
    let studentID: Int
    let points: Int
    let grade: Int
    let house: Int
    // Add other properties as needed

    init(name: String = "", studentID : Int = 000000, points: Int = 0, grade : Int = 0, house : Int = 0) {
        self.name = name
        self.studentID = studentID
        self.points = points
        self.grade = grade
        self.house = house
        // Initialize other properties with default values
    }
}

