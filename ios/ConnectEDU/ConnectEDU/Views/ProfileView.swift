//
//  ProfileView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-07.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    
                    Spacer()
                    
                    // Profile
                    VStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: geometry.size.height * 0.1))
                        
                        
                        // Page Title
                        Text("Profile")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.indigoPrimary)
                    }
                    .foregroundColor(.indigoPrimary)
                    
                    Spacer()
                    
                    VStack {
                        VStack {
                            // Points
                            HStack {
                                Text("Points:")
                                Button {
                                    navigationManager.navigate(to: .pointHistory)
                                } label: {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .padding(5)
                                        .background(.indigoPrimary)
                                        .cornerRadius(90)
                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                }
                                
                                Spacer()
                                
                                Text("\(viewModel.userProfile.points)")
                                    .padding(5)
                                    .background(.indigoPrimary)
                                    .cornerRadius(5)
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                            
                            Divider()
                                .overlay(.white)
                            
                            // Student ID
                            HStack {
                                Text("Student ID:")
                                Spacer()
                                Text(verbatim: "\(viewModel.userProfile.studentID)")
                                    .padding(5)
                                    .background(.indigoPrimary)
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                        .background(.indigoSecondary)
                        .cornerRadius(11)
                        
                        Spacer()
                        
                        VStack {
                            // Name
                            HStack {
                                Text("Name:")
                                Spacer()
                                Text("\(viewModel.userProfile.name)")
                                    .padding(5)
                                    .background(.indigoPrimary)
                                    .cornerRadius(5)
                            }
                            
                            Divider()
                                .overlay(.white)
                            
                            // Grade
                            HStack {
                                Text("Grade:")
                                Spacer()
                                Text("\(viewModel.userProfile.grade)")
                                    .padding(5)
                                    .background(.indigoPrimary)
                                    .cornerRadius(5)
                            }
                            
                            Divider()
                                .overlay(.white)
                            
                            // House
                            HStack {
                                Text("House:")
                                Spacer()
                                Text("\(viewModel.userProfile.house)")
                                    .padding(5)
                                    .background(.indigoPrimary)
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                        .background(.indigoSecondary)
                        .cornerRadius(11)
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(.txtPrimary)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.4)
                    
                    
                    Spacer()
                    
                    // Edit Profile
                    HStack {
                        Spacer()
                        
                        Button {
                            navigationManager.navigate(to: .editProfile)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title)
                                .bold()
                                .foregroundColor(.txtPrimary)
                                .padding(10)
                                .background(.indigoSecondary)
                                .cornerRadius(11)
                        }
                    }
                    .padding()
                }
                .padding()
                .padding(.top, 75)
                .offset(y: -1 * geometry.size.height * 0.035)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.85)
                
                VStack {
                    UpperNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.125), userProfile: viewModel.userProfile)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    LowerNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.125))
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileView()
        .environmentObject(eventsPreviewNavigationManager)
}
