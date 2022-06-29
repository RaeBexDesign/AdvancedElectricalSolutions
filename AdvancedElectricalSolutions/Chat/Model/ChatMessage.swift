//
//  ChatMessage.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/15/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
