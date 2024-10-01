//
//  HistoryViewModel.swift
//  AI
//
//  Created by Chichek on 18.08.24.
//

import Foundation
import FirebaseAuth

import FirebaseAuth

class HistoryViewModel {
    var conversations: [Conversation] = []
    let fileManagerHelper = FileManagerHelp()
   // var viewController = HistoryViewController()
    
    func savedConversations(completion: @escaping () -> Void) {
        fileManagerHelper.getMessages { [weak self] conversations in
            guard let self = self else { return }
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                completion()
                return
            }
            
            // Filter conversations by the current userID
            self.conversations = conversations.filter { $0.userID == currentUserID }
            self.sortConversations()
            completion()
        }
    }
    
    func saveConversation() {
        fileManagerHelper.saveConversation(data: conversations)
    }
    
    func setConversation(_ conversation: Conversation) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        var conversationToSave = conversation
        conversationToSave.userID = currentUserID // Ensure userID is assigned
        
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
            //    self.viewController.table.reloadData()
            }
        }
    }
}
