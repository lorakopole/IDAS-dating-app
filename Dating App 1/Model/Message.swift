//
//  Message.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Message: Identifiable
{
    
    var id: String { "\(String(timestamp.nanoseconds))" }
    var fromId: String
    var toId: String
    var text: String
    var timestamp: Timestamp
    init(data: [String: Any])
    {
        fromId = data["fromId"] as? String ?? ""
        toId = data["toId"] as? String ?? ""
        text = data["text"] as? String ?? ""
        timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
