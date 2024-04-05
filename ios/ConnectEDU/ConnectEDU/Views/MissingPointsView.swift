//
//  MissingPointsView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-06.
//

import SwiftUI

struct MissingPointsView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var body: some View {
        VStack {
            Text("WIP Page: Missing Points")
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
    MissingPointsView()
 }
