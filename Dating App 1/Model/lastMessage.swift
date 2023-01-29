//
//  chatedUserShortcut.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import Foundation
import Firebase

struct lastMessage
{
    var fromId: String
    var toId: String
    var lastMessage: String
    var timestamp: Timestamp
    
    init(data: [String: Any])
    {
        self.fromId = Auth.auth().currentUser?.uid ?? ""
        self.toId = data["userId"] as? String ?? ""
        self.lastMessage = data["lastMessage"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
