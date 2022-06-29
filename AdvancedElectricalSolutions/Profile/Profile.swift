//
//  Profile.swift
//  AES
//
//  Created by Josias Ballard on 1/28/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, username, imageName: String
}


