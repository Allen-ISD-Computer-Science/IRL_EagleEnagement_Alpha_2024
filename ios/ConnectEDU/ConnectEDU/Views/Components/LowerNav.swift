//
//  LowerNav.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-07.
//

import SwiftUI

struct LowerNav: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    var body: some View {
        HStack {
            Button {
                navigationManager.navigate(to: .clubs)
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: size.height / 3))
                    
                    Text("Clubs")
                        .font(.subheadline)
                }
                .foregroundColor(navigationManager.currentPage == .clubs ? .txtPrimary : .txtSecondary)
                .padding(.leading, 40)
            }
            
            Spacer()
            
            Button {
                navigationManager.navigate(to: .events)
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: size.height / 3))
                    
                    Text("Events")
                        .font(.subheadline)
                }
                .foregroundColor(navigationManager.currentPage == .events ? .txtPrimary : .txtSecondary)
            }
            
            
            Spacer()
            
            Button {
                navigationManager.navigate(to: .rewards)
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "medal.fill")
                        .font(.system(size: size.height / 3))
                    
                    Text("Rewards")
                        .font(.subheadline)
                }
                .foregroundColor(navigationManager.currentPage == .rewards ? .txtPrimary : .txtSecondary)
                .padding(.trailing, 40)
            }
            
        }
        .frame(width: size.width, height: size.height)
        .background(.indigoPrimary)
        .foregroundColor(.txtPrimary)
        .cornerRadius(44)
        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

    }
}

#Preview {
    GeometryReader { geometry in
        LowerNav(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.15))
            .environmentObject(loginPreviewNavigationManager)
    }
}
