//
//  RewardsView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-07.
//

import SwiftUI

struct RewardsView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel = RewardsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // Rewards Feed
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20) // Adjust this value to control the initial gap
                        
                        ForEach(viewModel.rewards) { reward in
                            RewardCard(reward: reward)
                                .padding(.top, reward == viewModel.rewards.first ? 55 : 10) // Adjust this value to match the initial gap
                                .padding(.bottom, reward == viewModel.rewards.last ? 75 : 0)
                            
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.85)
                .background(.white)
                .navigationBarTitle("Rewards")
                .onAppear {
                    viewModel.getRewards()
                }
                
                // Nav group
                VStack {
                    UpperNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.125), userProfile: viewModel.userProfile ?? Profile(name: "Error", studentID: 999999, points: 0, grade: 13, house: 900))
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    LowerNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.125))
                }
                .onAppear {
                    viewModel.getProfile()
                }
                // =========================
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RewardsView()
        .environmentObject(eventsPreviewNavigationManager)
}
