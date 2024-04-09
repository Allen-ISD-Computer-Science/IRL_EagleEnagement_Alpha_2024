//
//  PointHistoryView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-04-04.
//

import SwiftUI

struct PointHistoryView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel = PointHistoryViewModel()
    
    var body: some View {
        // TODO: Implement Points History page and API Support
        GeometryReader { geometry in
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20) // Adjust this value to control the initial gap
                        
                        Text("This is an event")
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.85)
                .background(.white)
                .navigationBarTitle("Events")
                .onAppear {
                    viewModel.getPointHistory()
                }
                
                Text("Test \(viewModel.pointHistoryListObjects)")
                    .onAppear {
                        viewModel.getPointHistory()
                    }
                
                VStack {
                    UpperHeader(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.175), pageTitle: "Point History")
                    
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PointHistoryView()
}

