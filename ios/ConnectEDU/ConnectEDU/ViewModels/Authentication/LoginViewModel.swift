//
//  LoginViewModel.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import Foundation

class LoginViewModel: ObservableObject {
    // Initializes the navigation manager for the login page to later be inputted
    private var loginNavigationManager: NavigationManager

    // User Input Fields
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginMessage: String = ""

    // Stores the Auth Result for displaying the correct "color" of resulting message
    var loginAuthResult: Bool = false

    init(navigationManager: NavigationManager) {
        self.loginNavigationManager = navigationManager
    }

    // Attempts a user login API request and handles the response properly
    func login() {
        APIService.login(email: email, password: password) { result, message in
            DispatchQueue.main.async {
                if result == true {
                    self.loginAuthResult = true
                    self.loginNavigationManager.updateAuthenticationState(withToken: message)
                    self.loginMessage = "Login successful! Redirecting..."
                } else {
                    self.loginAuthResult = false
                    self.loginMessage = "Invalid Email and or Password"
                }
            }
        }
    }
}
