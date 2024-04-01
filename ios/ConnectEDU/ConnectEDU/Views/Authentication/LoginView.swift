//
//  LoginView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AuthBackground()
                
                VStack {
                    // Logo
                    AuthLogo()
                        .frame(width: geometry.size.width)
                    
                    // Page Title
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.txtPrimary)
                    
                    Spacer()
                    
                    VStack {
                        
                        // Email Input Field
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                        // Password Input Field
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                        Button {
                            navigationManager.navigate(to: .forgotPassword)
                        } label: {
                            Text("Forgot Password?")
                                .foregroundColor(.linkPrimary)
                        }
                        
                        VStack {
                            Button {
                                viewModel.login()
                                
                                if viewModel.loginAuthResult {
                                    navigationManager.navigate(to: .events)
                                }
                            } label: {
                                Text("Login")
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
                        
                        Button {
                            navigationManager.navigate(to: .signup)
                        } label: {
                            Text("Don't have an account? Sign Up")
                                .foregroundColor(.linkPrimary)
                        }
                    }
                    .padding()
                }
            }
        }
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
