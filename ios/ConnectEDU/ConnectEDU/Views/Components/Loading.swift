//
//  Loading.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-28.
//

import SwiftUI

struct Loading: View {
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        Circle()
            .trim(from: 0.0,to: spinnerLength)
            .stroke(LinearGradient(colors: [.indigoSecondary,.indigoPrimary], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 8.0,lineCap: .round,lineJoin:.round))
            .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true))
            .frame(width: 60,height: 60)
            .rotationEffect(Angle(degrees: Double(degree)))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear{
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}

#Preview {
    Loading()
}
