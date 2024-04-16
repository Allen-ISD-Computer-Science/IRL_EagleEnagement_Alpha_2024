//
//  MissingPointsView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-06.
//

import SwiftUI

struct MissingPointsView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel = MissingPointsViewModel()
    @State var selectedEvent : String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    Form {
                        Picker("Select an event", selection: $selectedEvent) {
                            ForEach(viewModel.eventHistory, id: \.self) {
                                Text($0)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .onAppear {
                            viewModel.getEventHistory()
                        }
                        
                    }
                    
                    Text("\(selectedEvent ?? "There is no event")")
                }
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6)
                
                VStack {
                    UpperHeader(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.175), pageTitle: "Missing Points")
                    
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MissingPointsView()
}
