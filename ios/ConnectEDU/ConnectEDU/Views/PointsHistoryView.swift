//
//  PointsHistoryView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-27.
//

import SwiftUI

struct PointsHistoryView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var body: some View {
        // TODO: Implement Points History page and API Support
        VStack {
            Text("WIP Page: Points History")
                .font(.title2)
                .bold()
            
            Button {
                navigationManager.back()
            } label: {
                Image(systemName: "chevron.backward")
                    .bold()
                    .foregroundColor(.txtPrimary)
                    .padding()
                    .background(.indigoPrimary)
                    .cornerRadius(90)
            }
        }
    }
}

#Preview {
    PointsHistoryView()
}
