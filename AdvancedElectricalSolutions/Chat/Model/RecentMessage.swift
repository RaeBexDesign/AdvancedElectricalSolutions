//
//  RecentMessage.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/15/22.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Codable,Identifiable {
    
    @DocumentID var id: String?
    
    let text, username: String
    let fromId, toId: String
    let imageName: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
}
