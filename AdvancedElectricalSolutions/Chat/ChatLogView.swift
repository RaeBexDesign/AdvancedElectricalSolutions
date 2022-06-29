//
//  ChatLogView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/11/22.
//

import SwiftUI
import Firebase


class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    var userProfile: UserProfile?
    
    init(userProfile: UserProfile?) {
        self.userProfile = userProfile
        
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        guard let fromId =
                FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = userProfile?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let cm = try
                                change.document.data(as: ChatMessage.self) {
                                self.chatMessages.append(cm)
                                print("Appending chatMessage in ChatLogView: \(Date())")
                            }
                        } catch {
                            print("Failed to decode message: \(error)")
                        }
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId =
                FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = userProfile?.uid else { return }
                
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        
        try? document.setData(from: messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to send message into Firestore: \(error)"
                return
            }
            
            print("Succesfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        try? recipientMessageDocument.setData(from: messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to send message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        
        guard let userProfile = userProfile else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.userProfile?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.imageName: userProfile.imageName,
            FirebaseConstants.username: userProfile.username
        ] as [String: Any]
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.imageName: currentUser.imageName,
            FirebaseConstants.username: currentUser.username
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
        
    }
    
    @Published var count = 0
}

struct ChatLogView: View {
    
//    let userProfile: UserProfile?
//
//    init(userProfile: UserProfile?) {
//        self.userProfile = userProfile
//        self.vm = .init(userProfile: userProfile)
//    }
    
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        ZStack {
            
            messagesView
            Text(vm.errorMessage)
            
        }
        .navigationTitle(vm.userProfile?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private var chatBottomBar: some View {
        
        HStack {
            
            Button {
                
            } label: {
                Image(systemName: "camera.fill")
                    .scaleEffect(1.5)
                    .foregroundColor(Color(.lightGray))
            }
            
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                vm.handleSend()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .scaleEffect(2)
            }

            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                // Message being sent - blue background
                HStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Text(message.text)
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                
            } else {
                // Message being recieved - white background
                HStack {
                    HStack {
                        
                        Text(message.text)
                            .foregroundColor(.black)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    
                    Spacer()
                    
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Message")
                .foregroundColor(.secondary)
                .font(.system(size: 20))
                .padding(.leading, 5)
            Spacer()
        }
    }
}


struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
//            ChatLogView()
        ChatView()
    }
}