//
//  Conversation.swift
//  AI
//
//  Created by Chichek on 08.08.24.
//

import Foundation

struct Conversation: Codable {
    let id: UUID
    var messages: [ChatMessage]
    var userID: String
    var pinned: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case messages
        case userID = "user_id"
        case pinned
    }
}
