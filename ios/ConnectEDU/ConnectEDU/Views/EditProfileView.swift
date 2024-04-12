//
//  EditProfileView.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-27.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var viewModel = EditProfileViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TextField("Name", text: $viewModel.name)
                    
                    TextField("Student ID", value: $viewModel.studentID, format: .number)
                    
                    TextField("Grade", value: $viewModel.grade, format: .number)
                    
                    TextField("House", value: $viewModel.house, format: .number)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(/*@START_MENU_TOKEN@*/ .none/*@END_MENU_TOKEN@*/)
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                .onAppear {
                    viewModel.getProfile()
                }
                
                VStack {
                    UpperHeader(size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.175), pageTitle: "Edit Profile")
                    
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//        VStack {
//            Text("WIP Page: Edit Profile")
//                .font(.title2)
//                .bold()
//            
//            Button {
//                navigationManager.back()
//            } label: {
//                Image(systemName: "chevron.backward")
//                    .bold()
//                    .foregroundColor(.txtPrimary)
//                    .padding()
//                    .background(.indigoPrimary)
//                    .cornerRadius(90)
//            }
//        }
    }
}

#Preview {
    EditProfileView()
}
