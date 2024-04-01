//
//  RewardCard.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-26.
//

import SwiftUI

struct RewardCard: View {
    var reward: RewardListObject
    
    var body: some View {
        VStack {
            HStack {
//                Image("reward-placeholder")
                
                Spacer()
                
                Text("\(reward.name)")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Text("\(reward.cost)")
            }
            
            Spacer()
            
            Text("\(reward.description)")
                .font(.headline)
            
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 142)
        .background(.indigoPrimary)
        .foregroundColor(.txtPrimary)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

#Preview {
    RewardCard(reward: RewardListObject(id: 1, name: "Fake Reward", description: "Fake Description that goes on for an unbelievable long time which takes up a lot of lines and should be truncated", cost: 100))
}
