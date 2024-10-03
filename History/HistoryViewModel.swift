//
//  HistoryViewModel.swift
//  AI
//
//  Created by Chichek on 18.08.24.
//

import Foundation
import FirebaseAuth

class HistoryViewModel {
    var conversations: [Conversation] = []
    let fileManagerHelper = FileManagerHelp()

    func savedConversations(completion: @escaping () -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        fileManagerHelper.getConversations(for: currentUserID) { [weak self] conversations in
            guard let self = self else { return }
            
            self.conversations = conversations
            self.sortConversations()
            completion()
        }
    }

    func saveConversation() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        fileManagerHelper.saveConversations(data: conversations, for: currentUserID)
    }

    func setConversation(_ conversation: Conversation) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        var conversationToSave = conversation
        conversationToSave.userID = currentUserID
        
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversationToSave
        } else {
            conversations.append(conversationToSave)
        }
        
        sortConversations()
        saveConversation()
    }

    func deleteConversation(withId id: UUID) {
        conversations.removeAll { $0.id == id }
        saveConversation()
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

    func loadUserConversations() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        savedConversations {
            DispatchQueue.main.async {
                self.conversations = self.conversations.filter { $0.userID == user.uid }
            }
        }
    }
}

