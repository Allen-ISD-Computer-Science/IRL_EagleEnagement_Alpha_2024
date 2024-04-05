//
//  ForgotPasswordView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-08.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel: ForgotPasswordViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AuthBackground()
                
                VStack {
                    // Logo
                    AuthLogo()
                        .frame(width: geometry.size.width)
                    
                    // Page Title
                    Text("Forgot Password")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.txtPrimary)
                    
                    Spacer()
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    
                    TextField("Student ID", text: $viewModel.str_studentID)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    VStack {
                        Button {
                            viewModel.forgotPassword()

                            if viewModel.forgotPasswordAuthResult {
                                navigationManager.navigate(to: .events)
                            }
                        } label: {
                            Text("Verify")
                        }
                        .padding()
                        .background(.indigoSecondary)
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .cornerRadius(10)
                        .padding()

                        Text(viewModel.forgotPasswordMessage)
                            .foregroundColor(viewModel.forgotPasswordAuthResult ? .green : .red)
                            .padding()
                        
                        Spacer()
                    }
                    
                    Button {
                        navigationManager.navigate(to: .login)
                    } label: {
                        Text("Changed your mind? Login")
                            .foregroundColor(.linkPrimary)
                    }
                }
            }
        }
    }
}

// Create a sample or mock NavigationManager for preview purposes
let forgotPasswordPreviewNavigationManager = NavigationManager()

// Initialize ForgotPasswordViewModel with the preview NavigationManager
let forgotPasswordPreviewViewModel = ForgotPasswordViewModel(navigationManager: forgotPasswordPreviewNavigationManager)

struct forgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        // Inject the preview ViewModel into VerifyView
        ForgotPasswordView(viewModel: forgotPasswordPreviewViewModel)
            .environmentObject(forgotPasswordPreviewNavigationManager)
    }
}
