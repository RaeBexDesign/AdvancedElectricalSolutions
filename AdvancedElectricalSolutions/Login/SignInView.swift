//
//  SignInView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 2/10/22.
//

import SwiftUI
import FirebaseAuth
import Firebase

class AppViewModel: ObservableObject {
    
    @Published var signedIn = false
    
    @State var loginStatusMessage = ""
    
    var isSignedIn: Bool {
        return FirebaseManager.shared.auth.currentUser != nil
    }

    func signIn(email: String, password: String) {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {  result, error in
            if let error = error {
                print("Failed to login user:", error)
                self.loginStatusMessage = "Failed to login user: \(error)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
        }
    }
    
    func signOut() {
        try? FirebaseManager.shared.auth.signOut()
        
        self.signedIn = false 
    }
    
}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        VStack {
            
            if viewModel.signedIn {
                TabBarView()
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
        
    }
}

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 16){
                
                Image("AES Logo")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding(.bottom, 50)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(12)
                    .font(.title3)
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .padding(12)
                    .font(.title3)
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    viewModel.signIn(email: email, password: password)
                }, label: {
                    Text("Sign In")
                        .frame(width: 200, height: 50)
                        .font(.title3)
                        .background(Color("Blue"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                
                Text(self.loginStatusMessage)
                    .foregroundColor(.red)
                
            }
            .navigationTitle("Log In")
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
