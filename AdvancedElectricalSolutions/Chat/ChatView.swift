//
//  ChatView.swift
//  AES
//
//  Created by Josias Ballard on 1/26/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var userProfile: UserProfile?
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?
    
    private func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self) {
                        self.recentMessages.insert(rm, at: 0)
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                })
            }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch user:", error)
                return
            }
            
            self.userProfile = try? snapshot?.data(as: UserProfile.self)
            FirebaseManager.shared.currentUser = self.userProfile
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }

}


struct ChatView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    private var chatLogViewModel = ChatLogViewModel(userProfile: nil)
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                customNavBar
                messagesView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(vm: chatLogViewModel)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
            
            
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            Image(vm.userProfile?.imageName ?? "")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(vm.userProfile?.username ?? "")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
            }
            
            Spacer()
            
            VStack {
                
                Button {
                    shouldShowLogOutOptions.toggle()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                    
                }
                .padding(.bottom)
                
            }
          
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    viewModel.signOut()
                }),
                    .cancel()
            ])
        }
        
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        self.userProfile = .init(id: uid, uid: uid, username: recentMessage.username, imageName: recentMessage.imageName)
                        
                        self.chatLogViewModel.userProfile = self.userProfile
                        self.chatLogViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
                            Image(recentMessage.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.primary, lineWidth: 1))
                                .shadow(radius: 5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.username)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.leading)
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            
                            Text(recentMessage.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                    }

                    Divider()
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
            }
            .refreshable {
                
            }
            .padding(.bottom, 50)
        }
    }
    
    @State var shouldShowNewMessageScreen = false
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView(didSelectNewUser: { user in
                print(user.username)
                self.shouldNavigateToChatLogView.toggle()
                self.userProfile = user
                self.chatLogViewModel.userProfile = user
                self.chatLogViewModel.fetchMessages()
            })
        }
        .padding(.bottom)
    }

    @State var userProfile: UserProfile?
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
