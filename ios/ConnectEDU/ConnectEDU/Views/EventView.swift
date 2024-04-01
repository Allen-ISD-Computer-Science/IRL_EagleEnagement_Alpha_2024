//
//  EventView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-06.
//

import SwiftUI

struct EventView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var event_id: Int
    @StateObject var viewModel: EventViewModel
    
    init(event_id: Int) {
        self.event_id = event_id
        _viewModel = StateObject(wrappedValue: EventViewModel(event_id: event_id))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let event = viewModel.eventFull {
                    // Display event details
                    ZStack {
                        VStack {
                            VStack(spacing:0) {
                                ZStack {
                                    Image("ae-stadium")
                                        .resizable()
                                        .scaledToFill()
                                        .blur(radius: 1.5)
                                        .brightness(-0.1)
                                        
                                    
                                    VStack {
                                        
                                        HStack {
                                            Button {
                                                navigationManager.navigate(to: .events)
                                            } label: {
                                                Image(systemName: "chevron.backward")
                                                    .font(.title)
                                                    .bold()
                                                    .foregroundStyle(.whitePrimary)
                                            }
                                            
                                            Spacer()
                                            
                                            Text("\(event.pointsWorth)")
                                                .foregroundStyle(.whitePrimary)
                                                .font(.title2)
                                                .bold()
                                                .padding()
                                                .background(.indigoPrimary)
                                                .cornerRadius(90)
                                        }
                                        Text("\(event.name)")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(.whitePrimary)
                                        
                                    }
                                    .padding()
                                }
                                
                                Divider()
                                    .frame(height: 2)
                                    .overlay(.white)
                                
                                ZStack {
                                    UnevenRoundedRectangle(cornerRadii: .init(
                                        topLeading: 0,
                                        bottomLeading: 44,
                                        bottomTrailing: 44,
                                        topTrailing: 0),
                                                           style: .continuous
                                    )
                                    .frame(height: geometry.size.height * 0.2)
                                    .foregroundStyle(.indigoPrimary)
                                    
                                    HStack {
                                        VStack {
                                            Text("\(event.startDate.day())")
                                                .foregroundStyle(.black)
                                            
                                            Text("\(event.startDate.month())")
                                                .foregroundStyle(.txtSecondary)
                                        }
                                        .padding()
                                        .background(.white)
                                        .cornerRadius(22)
                                        
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Text("\(event.startDate.weekday())")
                                            Text("\(event.startDate.toHourMinuteFormat()) - \(event.endDate.toHourMinuteFormat())")
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "football.fill")
                                            .font(.system(size: 50))
                                        
                                    }
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                }
                                .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                            
                            Spacer()
                            
                            Group {
                                // Location
                                HStack {
                                    Image(systemName: "location.fill")
                                        .font(.title)
                                        .foregroundColor(.indigoPrimary)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(event.locationName)")
                                            .bold()
                                            .foregroundStyle(.indigoPrimary)
                                        
                                        Text("\(event.address)")
                                            .foregroundStyle(.indigoSecondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text("\(event.description)")
                                
                                Spacer()
                                
                                // Event Options
                                HStack {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "map.fill")
                                            .font(.title)
                                            .foregroundStyle(.indigoPrimary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "bell.fill")
                                            .font(.title)
                                            .foregroundStyle(.indigoPrimary)
                                    }
                                }
                                .frame(width: geometry.size.width * 0.5)
                                
                                Spacer()
                                
                                // Check In Button
                                Button {
                                    
                                } label: {
                                    Text("Check In")
                                        .foregroundStyle(.whitePrimary)
                                        .padding(25)
                                        .background(.indigoSecondary)
                                        .cornerRadius(22)
                                }
                            }
                        }
                    }
                    // Add more views to display other event properties
                } else {
                    Loading()
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .onAppear {
                viewModel.getEvent()
            }
        }
        // TODO: Fix placement so it doesnt go off screen so that stuff can be sized properly
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    EventView(event_id: 13)
}
