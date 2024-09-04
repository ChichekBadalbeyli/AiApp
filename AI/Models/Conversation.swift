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
    var user_id: String
    var pinned: Bool
}
