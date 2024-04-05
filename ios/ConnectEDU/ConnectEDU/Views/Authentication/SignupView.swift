//
//  SignupView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-05.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel: SignupViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AuthBackground()
                
                // Content
                VStack {
                    AuthLogo()
                        .frame(width: geometry.size.width)
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.txtPrimary)
                    
                    Spacer()
                    
                    // Input Boxes
                    VStack {
                        TextField("First Name", text: $viewModel.firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
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
                        
                        // Sign Up button + Error Message
                        VStack {
                            Button("Sign Up") {
                                viewModel.signup()
                                
                                if viewModel.signupAuthResult {
                                    navigationManager.navigate(to: .verify)
                                }
                            }
                            .padding()
                            .background(.indigoSecondary)
                            .foregroundColor(Color("txt-primary"))
                            .font(.title2)
                            .bold()
                            .cornerRadius(10)
                            .padding()
                            
                            Text(viewModel.signupMessage)
                                .foregroundColor(viewModel.signupAuthResult ? .green : .red)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    Button {
                        navigationManager.navigate(to: .login)
                    } label: {
                        Text("Already have an account? Login")
                            .foregroundColor(.linkPrimary)
                    }
                }
            }
        }
    }
}

// Create a sample or mock NavigationManager for preview purposes
let signupPreviewNavigationManager = NavigationManager()

// Initialize LoginViewModel with the preview NavigationManager
let signupPreviewViewModel = SignupViewModel(navigationManager: signupPreviewNavigationManager)

struct signupView_Previews: PreviewProvider {
    static var previews: some View {
        // Inject the preview ViewModel into LoginView
        SignupView(viewModel: signupPreviewViewModel)
            .environmentObject(signupPreviewNavigationManager) // If your LoginView still uses NavigationManager as an @EnvironmentObject
    }
}
