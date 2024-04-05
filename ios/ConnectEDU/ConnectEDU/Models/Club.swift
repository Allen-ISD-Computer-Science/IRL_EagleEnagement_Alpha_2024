//
//  Club.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import Foundation

struct Club: Codable {
    var name: String // Name of the club
    var description: String // Descritpion of the club
    var sponsors: String? // Sponsors of the Club
    var meetingTimes: String? // Meeting times in the string format
    var locationName: String? // Location Name (not the same as address)
    var websiteLink: String? // Links to the clubs website (if it exists)
    var instagramLink: String? // Same as above
    var twitterLink: String? // Same as above
    var youtubeLink: String? // Same as above
}

//POST /api/club/:id
//
//Returns { name: String, description: String, sponsors: String, meetingTimes: String?, locationName: String?, websiteLink: String?, instagramLink: String?, twitterLink: String?, youtubeLink: String? }
