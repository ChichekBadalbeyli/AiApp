//
//  FileManager.swift
//  AI
//
//  Created by Chichek on 03.08.24.
//
import Foundation
import FirebaseAuth

class FileManagerHelp {
    private let fileName = "conversations.json"
    
    // Function to get the current user's userID
    func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getFilePath() -> URL {
        guard let userID = getCurrentUserID() else {
            fatalError("No logged in user")
        }
        
        let fileNameWithUser = "\(userID)_\(fileName)"
        let files = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = files[0].appendingPathComponent(fileNameWithUser)
        print("File path: \(path)")
        return path
    }
    
    func saveConversation(data: [Conversation]) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: getFilePath(), options: .atomic)
            print("Conversations saved successfully.")
        } catch {
            print("Failed to save conversations: \(error.localizedDescription)")
        }
    }
    
    func getMessages(completion: @escaping ([Conversation]) -> Void) {
        do {
            let data = try Data(contentsOf: getFilePath())
            let conversations = try JSONDecoder().decode([Conversation].self, from: data)
            completion(conversations)
            print("Conversations loaded successfully.")
        } catch {
            print("Failed to load conversations: \(error.localizedDescription)")
            completion([])
        }
    }
    
    func deleteConversation(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        getMessages { [weak self] conversations in
            guard let self = self else {
                completion(false)
                return
            }
            
            guard indexPath.row < conversations.count else {
                completion(false)
                return
            }
            var updatedConversations = conversations
            updatedConversations.remove(at: indexPath.row)
            self.saveConversation(data: updatedConversations)
            completion(true)
        }
    }
}

