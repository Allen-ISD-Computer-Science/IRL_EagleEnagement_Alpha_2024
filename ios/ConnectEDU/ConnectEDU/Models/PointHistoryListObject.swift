//
//  PointHistoryListObject.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-04-04.
//

import Foundation

struct PointHistoryListObject: Codable, Equatable {
    let reason: String
    let points: Int
    let date: Date
}
