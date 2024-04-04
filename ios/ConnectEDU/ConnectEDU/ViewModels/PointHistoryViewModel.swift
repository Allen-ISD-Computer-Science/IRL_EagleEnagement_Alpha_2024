//
//  PointHistoryViewModel.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-04-04.
//

import Foundation

class PointHistoryViewModel: ObservableObject {
    
    @Published var pointHistoryListObjects: [PointHistoryListObject] = .init()
    
    func getPointHistory() {
        APIService.fetchPointHistory { pointHistoryListObjects, error in
            if let pointHistoryListObjects = pointHistoryListObjects {
                self.pointHistoryListObjects = pointHistoryListObjects
            } else if let error = error {
                print("Error when retrieving events Error: \(error)")
            }
        }
    }
    
}
