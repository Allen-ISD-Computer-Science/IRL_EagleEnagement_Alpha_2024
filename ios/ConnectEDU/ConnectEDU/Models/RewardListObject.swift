//
//  RewardListObject.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-26.
//

import Foundation

struct RewardListObject: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var description: String
    var cost: Int
}
