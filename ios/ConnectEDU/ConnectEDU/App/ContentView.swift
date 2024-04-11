//
//  ContentView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-01.
//

import SwiftUI

struct ContentView: View {
//    @ObservedObject var navigationManager = NavigationManager.shared
    @ObservedObject var navigationManager = NavigationManager.shared

    var body: some View {
        Group {
            switch navigationManager.currentPage {
            case .login:
                LoginView(viewModel: LoginViewModel(navigationManager: navigationManager))
            case .forgotPassword:
                ForgotPasswordView(viewModel: ForgotPasswordViewModel(navigationManager: navigationManager))
            case .signup:
                SignupView(viewModel: SignupViewModel(navigationManager: navigationManager))
            case .verify:
                VerifyView(viewModel: VerifyViewModel(navigationManager: navigationManager))
            case .events:
                EventsView()
            case .dev:
                DevView()
            case .missingPoints:
                MissingPointsView()
            case .profile:
                ProfileView()
            case .clubs:
                ClubsView()
            case .rewards:
                RewardsView()
            case .eventDetail:
                EventView(event_id: navigationManager.currentEventID ?? 0)
            case .clubDetail:
                ClubView(club_id: navigationManager.currentClubID ?? 0)
            case .editProfile:
                EditProfileView()
            case .pointHistory:
                PointHistoryView()
            default:
                Text("Page does not exist")
                // Add other cases as needed
            }
        }
        .onTapGesture(count: 3) {
            navigationManager.currentPage == .dev ? navigationManager.back() : navigationManager.navigate(to: .dev)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of NavigationManager for previews.
        // You might need to adjust its initial state depending on the view you want to preview.
        ContentView()
            .environmentObject(NavigationManager())
    }
}
