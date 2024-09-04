//
//  ChatMessage.swift
//  AI
//
//  Created by Chichek on 27.07.24.
//
import Foundation

struct ChatMessage: Codable {
    let role: String
    let content: String
    let isUser: Bool
}
