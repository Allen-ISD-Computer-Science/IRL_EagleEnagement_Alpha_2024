//
//  ClubView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-25.
//

import SwiftUI

struct ClubView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var club_id: Int
    @StateObject var viewModel: ClubViewModel
    
    init(club_id: Int) {
        self.club_id = club_id
        _viewModel = StateObject(wrappedValue: ClubViewModel(club_id: club_id))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let club = viewModel.clubFull {
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
                                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                    
                                    VStack {
                                        
                                        HStack {
                                            Button {
                                                navigationManager.navigate(to: .clubs)
                                            } label: {
                                                Image(systemName: "chevron.backward")
                                                    .font(.title)
                                                    .bold()
                                                    .foregroundStyle(.whitePrimary)
                                            }
                                            
                                            Spacer()
                                            
//                                            Text("\(event.pointsWorth)")
//                                                .foregroundStyle(.whitePrimary)
//                                                .font(.title2)
//                                                .bold()
//                                                .padding()
//                                                .background(.indigoPrimary)
//                                                .cornerRadius(90)
                                        }
                                        Text("\(club.name)")
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
                                    
                                    VStack {
                                        HStack {
                                            Text("Sponsor:\n\(club.sponsors ?? "No Sponsor")")
                                            
                                            Spacer()
                                            
                                            Text("Times:\n\(club.meetingTimes ?? "No Meeting Times")")
                                        }
                                        .font(.title2)
                                        .bold()
                                    .padding()
                                        
                                        Text("Location: \(club.locationName ?? "No Location")")
                                    }
                                    .padding()
                                }
                                .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                            
                            Spacer()
                            
                            Group {
                                Spacer()
                                
                                Text("\(club.description)")
                                
                                Spacer()
                                
                                // Event Options
                                HStack {
                                    if let websiteLink = club.websiteLink, !websiteLink.isEmpty {
                                        Link(destination: URL(string: websiteLink)!) {
                                            Image(systemName: "link")
                                                .font(.title)
                                                .foregroundStyle(.indigoPrimary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if let instagramLink = club.instagramLink, !instagramLink.isEmpty {
                                        Link(destination: URL(string: instagramLink)!) {
                                            Image("instagram-fill")
                                                .font(.title)
                                                .foregroundStyle(.indigoPrimary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if let twitterLink = club.twitterLink, !twitterLink.isEmpty {
                                        Link(destination: URL(string: twitterLink)!) {
                                            Image("twitter-fill")
                                                .font(.title)
                                                .foregroundStyle(.indigoPrimary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if let youtubeLink = club.youtubeLink, !youtubeLink.isEmpty {
                                        Link(destination: URL(string: youtubeLink)!) {
                                            Image("youtube-play-button-fill")
                                                .font(.title)
                                                .foregroundStyle(.indigoPrimary)
                                        }
                                    }
                                }
                                .frame(width: geometry.size.width * 0.5)

                                
//                                HStack {
//                                    Button {
//                                        
//                                    } label: {
//                                        Image(systemName: "link")
//                                            .font(.title)
//                                            .foregroundStyle(.indigoPrimary)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    Button {
//                                        
//                                    } label: {
//                                        Image("instagram-fill")
//                                            .font(.title)
//                                            .foregroundStyle(.indigoPrimary)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    Button {
//                                        
//                                    } label: {
//                                        Image("twitter-fill")
//                                            .font(.title)
//                                            .foregroundStyle(.indigoPrimary)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    Button {
//                                        
//                                    } label: {
//                                        Image("youtube-play-button-fill")
//                                            .font(.title)
//                                            .foregroundStyle(.indigoPrimary)
//                                    }
//                                }
//                                .frame(width: geometry.size.width * 0.5)
                                
                                Spacer()
                                
                                // Check In Button
                                Button {
                                    
                                } label: {
                                    Text("Follow")
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
                viewModel.getClub()
            }
        }
    }
}

#Preview {
    ClubView(club_id: 1)
}
