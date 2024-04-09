//
//  UpperHeader.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-04-04.
//

import SwiftUI

struct UpperHeader: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var size: CGSize
    var pageTitle: String
    
    init(size: CGSize, pageTitle: String) {
        self.size = size
        self.pageTitle = pageTitle
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Button {
                    navigationManager.back()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.whitePrimary)
                }
                
                Spacer()
                
                Text("\(pageTitle)")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
        }
        .padding(.bottom, 35)
        .padding(.horizontal, 30)
        .frame(width: size.width, height: size.height)
        .foregroundColor(.txtPrimary)
        .background(.indigoPrimary)
        .cornerRadius(44)
        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    UpperHeader(size: CGSize(width: 393, height: 150), pageTitle: "Best Page")
}
