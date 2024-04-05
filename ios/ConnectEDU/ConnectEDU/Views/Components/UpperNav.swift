//
//  UpperNav.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-07.
//

import SwiftUI

struct UpperNav: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var userProfile: Profile?
    var size: CGSize
    
    init(size: CGSize, userProfile: Profile) {
        self.size = size
        self.userProfile = userProfile
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    navigationManager.navigate(to: .missingPoints)
                } label: {
                    VStack {
                        Image(systemName: "flag.fill")
                            .font(.system(size: size.height / 3))
                        
                        Text("Request")
                            .font(.subheadline)
                    }
                    .foregroundColor(navigationManager.currentPage == .missingPoints ? .txtPrimary : .txtSecondary)
                    //                .offset(y: -10)
                    .padding(.leading, 40)
                }
                
                Spacer()
                
                Button {
                    navigationManager.navigate(to: .profile)
                } label: {
                    VStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: size.height / 3))
                        
                        Text("Profile")
                            .font(.subheadline)
                    }
                    .foregroundColor(navigationManager.currentPage == .profile ? .txtPrimary : .txtSecondary)
                    //                .offset(y: -10)
                    .padding(.trailing, 40)
                }
            }
            HStack {
                Spacer()
                
                // POINTS PLACEHOLDER INSERT API STUFF HERE
                Text("\(userProfile?.points ?? 999)")
                    .font(.system(size: size.height / 4))
                    .bold()
    //                .offset(y: 20)
                
                Spacer()
            }
        }
        .frame(width: size.width, height: size.height)
        .foregroundColor(.txtPrimary)
        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .colorInvert()
        
    }
}

#Preview {
    GeometryReader { geometry in
        UpperNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.15), userProfile: Profile(
            name: "John",
            studentID: 999999,
            points: 999,
            grade: 13,
            house: 900
        ))
        .environmentObject(loginPreviewNavigationManager)
    }
}

//let name: String
//let studentID: Int
//let points: Int
//let grade: Int
//let house: Int
