//
//  ChatStruct.swift
//  AI
//
//  Created by Chichek on 25.07.24.
//

import Foundation

struct ChatStruct: Codable {
    let id: String
    let created: Int
    let model: String
    let choices: [Choices]
    let usage: Usage
}

struct Choices: Codable {
    let index: Int
    let message: Message
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}


