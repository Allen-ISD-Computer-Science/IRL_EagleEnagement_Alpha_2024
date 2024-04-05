//  DevView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-05.

import SwiftUI

struct DevView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Navigation State")) {
                    Text("Current Page: \(navigationManager.currentPage.rawValue)")
                    Text("Current PageStack: \(navigationManager.dump())")
                    Text("Current EventDetailID: \(navigationManager.currentEventID ?? 999)")
                    Button("Clear Stack") {
                        navigationManager.popToRoot()
                    }
                    ForEach(NavigationManager.Page.allCases, id: \.self) { page in
                        Button("Set Page to \(page.rawValue)") {
                            navigationManager.navigate(to: page)
                        }
                    }
                }

                Section(header: Text("User Data")) {
                    Text("User Token: \(KeychainService.shared.retrieveToken() ?? "No Token")")
                    Button("Delete Token") {
                        KeychainService.shared.deleteToken()
                    }
                }
            }
            .navigationBarTitle("Dev Tools", displayMode: .inline)
        }
    }
}

struct DevView_Previews: PreviewProvider {
    static var previews: some View {
        DevView()
            .environmentObject(NavigationManager())
            .previewDisplayName("Dev View")
    }
}
