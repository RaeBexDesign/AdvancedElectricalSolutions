//
//  FirebaseManager.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/10/22.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: UserProfile?
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
