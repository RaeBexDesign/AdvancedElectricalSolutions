//
//  CreateNewMessageView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/11/22.
//

import SwiftUI

class CreateNewMessagesViewModel: ObservableObject {
    
    @Published var users = [UserProfile]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }
            
            documentsSnapshot?.documents.forEach({ snapshot in
                let user = try? snapshot.data(as: UserProfile.self)
                if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(user!)
                }
            })
            
        }
        
    }
}

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (UserProfile) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessagesViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                        
                    } label: {
                        
                        HStack(spacing: 16) {
                            
                            Image(user.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 1))
                            
                            Text(user.username)
                                .foregroundColor(Color(.label))
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                }
                
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//       CreateNewMessageView()
        ChatView()
    }
}
