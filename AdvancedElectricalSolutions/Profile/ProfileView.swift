//
//  ProfileView.swift
//  AES
//
//  Created by Josias Ballard on 1/26/22.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var prefersNotifications : Bool = true
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        
        ZStack {
//            Color.white
//                .ignoresSafeArea()
            
            VStack {
                
                VStack(spacing: 10) {
                    
                    ProfileCircleImage()
                        .padding(.top, 40.0)
                    
                    Text(vm.userProfile?.username ?? "")
                        .bold()
                        .font(.title)
                    
                    Toggle("Notifications: \(prefersNotifications ? "On": "Off" )", isOn: $prefersNotifications)
                        .padding()
                    
                    
                    
                    
                    Spacer()
                    
                }
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
