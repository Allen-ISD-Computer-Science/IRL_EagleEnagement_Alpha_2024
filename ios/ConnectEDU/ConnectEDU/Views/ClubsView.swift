//
//  ClubsView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-07.
//

import SwiftUI

struct ClubsView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel = ClubsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20) // Adjust this value to control the initial gap
                        
                        ForEach(viewModel.clubs) { club in
                            Button {
                                navigationManager.goToClubDetail(with: club.id)
                            } label: {
                                ClubCard(club: club)
                                    .padding(.top, club == viewModel.clubs.first ? 55 : 10) // Adjust this value to match the initial gap
                                    .padding(.bottom, club == viewModel.clubs.last ? 75 : 0)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.85)
                .background(.white)
                .navigationBarTitle("Clubs")
                .onAppear {
                    viewModel.getClubs()
                }
                
                VStack {
                    UpperNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.125), userProfile: viewModel.userProfile ?? Profile(name: "Error", studentID: 999999, points: 0, grade: 13, house: 900))
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    LowerNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.125))
                }
                .onAppear {
                    viewModel.getProfile()
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//        GeometryReader { geometry in
//            ZStack {
//                VStack {
//                    LowerNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.15))
//                }
//            }
//        }
    }
}

#Preview {
    ClubsView()
        .environmentObject(eventsPreviewNavigationManager)
}
