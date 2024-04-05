//
//  Endpoints.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import Foundation

enum Endpoints {
    // Base API for the users vapor portal
    static let baseAPIURL = "https://stg.codermerlin.academy/vapor/logan-rohlfs/api"

    // Auth
    static let login = "\(baseAPIURL)/login/"
    static let signup = "\(baseAPIURL)/signup/"
    static let forgotPassword = "\(baseAPIURL)/forgotPassword/"
    static let verify = "\(baseAPIURL)/verify/"
    static let logOutAll = "\(baseAPIURL)/logOutAll/"

    // Profile
    static let profile = "\(baseAPIURL)/profile/"
    
    // Events
    static let events = "\(baseAPIURL)/events/"
    static let event = "\(baseAPIURL)/event/"
    
    // Clubs
    static let clubs = "\(baseAPIURL)/clubs/"
    static let club = "\(baseAPIURL)/club/"
    
    // Rewards
    static let rewards = "\(baseAPIURL)/rewards/"
    
    // Other endpoints...
}
