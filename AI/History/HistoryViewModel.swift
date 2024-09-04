//
//  HistoryViewModel.swift
//  AI
//
//  Created by Chichek on 18.08.24.
//

import Foundation

class HistoryViewModel {
    
    var conversations: [Conversation] = []
    let fileManagerHelper = FileManagerHelp()
    
    func savedConversations(completion: @escaping () -> Void) {
        fileManagerHelper.getMessages { [weak self] conversations in
            guard let self = self else { return }
            self.conversations = conversations
            self.sortConversations()
            completion()
        }
    }
    
    func saveConversation() {
        print("Saving conversations: \(conversations)")
        fileManagerHelper.saveConversation(data: conversations)
    }
    
    func setConversation(_ conversation: Conversation) {
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
        } else {
            conversations.append(conversation)
        }
        sortConversations()
        saveConversation()
    }
    
    func deleteConversation(withId id: UUID) {
        conversations.removeAll { $0.id == id }
        saveConversation()
    }
    
    func pinConversation(_ conversation: Conversation) {
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index].pinned = true
            sortConversations()
            saveConversation()
        }
    }
    
    func sortConversations() {
        conversations.sort {
            if $0.pinned != $1.pinned {
                return $0.pinned && !$1.pinned
            } else {
                return $0.id.uuidString < $1.id.uuidString
            }
        }
    }
}
