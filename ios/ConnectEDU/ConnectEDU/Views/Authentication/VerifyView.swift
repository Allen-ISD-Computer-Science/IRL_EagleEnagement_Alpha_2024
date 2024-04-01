//
//  VerifyView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-05.
//

import SwiftUI

struct VerifyView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel: VerifyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AuthBackground()
                
                VStack {
                    AuthLogo()
                        .frame(width: geometry.size.width)
                    
                    Text("Verify")
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
                    
                    TextField("Code", text: $viewModel.token)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    TextField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .autocapitalization( .none)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    TextField("Confirm Password", text: $viewModel.passwordConfirm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    // Verify Button
                    
                    VStack {
                        Button {
                            viewModel.verify()

                            if viewModel.verifyAuthResult {
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

                        Text(viewModel.verifyMessage)
                            .foregroundColor(viewModel.verifyAuthResult ? .green : .red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        navigationManager.navigate(to: .login)
                    } label: {
                        Text("Already have an account? Sign In")
                            .foregroundColor(.linkPrimary)
                    }
                    
//                Reference
//                  email: String
//                  token: String
//                  password: String
//                  passwordConfirm: String
                    
                }
            }
        }
    }
}

// Create a sample or mock NavigationManager for preview purposes
let verifyPreviewNavigationManager = NavigationManager()

// Initialize VerifyViewModel with the preview NavigationManager
let verifyPreviewViewModel = VerifyViewModel(navigationManager: verifyPreviewNavigationManager)

struct verifyView_Previews: PreviewProvider {
    static var previews: some View {
        // Inject the preview ViewModel into VerifyView
        VerifyView(viewModel: verifyPreviewViewModel)
            .environmentObject(verifyPreviewNavigationManager) // If LoginView still uses NavigationManager as an @EnvironmentObject
    }
}
