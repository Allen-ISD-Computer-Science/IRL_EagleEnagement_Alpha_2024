//
//  LoginView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    AuthBackground()

                    VStack {
                        Image("cedu-logo-full")
                            .resizable()
                            .frame(height: geometry.size.height * 0.3)
                            .padding()

                        Text("Login")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.txtPrimary)
                        
                        Spacer()
                        
                        VStack {
                            TextField("Email", text: $viewModel.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal)
                                .padding(.vertical, 10)

                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal)
                                .padding(.vertical, 10)

                            VStack {
                                Button("Login") {
                                    viewModel.login()

                                    if viewModel.loginAuthResult {
                                        navigationManager.navigate(to: .home)
                                    }
                                }
                                .padding()
                                .background(.indigoSecondary)
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                                .cornerRadius(10)
                                .padding()

                                Text(viewModel.loginMessage)
                                    .foregroundColor(viewModel.loginAuthResult ? .green : .red)
                                    .padding()
                            }

                            Spacer()

                            Button("Don't have an account? Sign Up") {
                                navigationManager.navigate(to: .signup)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Create a sample or mock NavigationManager for preview purposes
let loginPreviewNavigationManager = NavigationManager()

// Initialize LoginViewModel with the preview NavigationManager
let loginPreviewViewModel = LoginViewModel(navigationManager: loginPreviewNavigationManager)

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // Inject the preview ViewModel into LoginView
        LoginView(viewModel: loginPreviewViewModel)
            .environmentObject(loginPreviewNavigationManager) // If your LoginView still uses NavigationManager as an @EnvironmentObject
    }
}
