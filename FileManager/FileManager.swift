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
    
    func getFilePath() -> URL {
        let files = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = files[0].appendingPathComponent(fileName)
        print("File path: \(path)")
        return path
    }
    
    func saveConversations(data: [Conversation], for userID: String) {
        getAllConversations { [weak self] allConversations in
            guard let self = self else { return }

            var updatedConversations = allConversations
            updatedConversations[userID] = data
            do {
                let encodedData = try JSONEncoder().encode(updatedConversations)
                try encodedData.write(to: self.getFilePath(), options: .atomic)
                print("Conversations for user \(userID) saved successfully.")
            } catch {
                print("Failed to save conversations: \(error.localizedDescription)")
            }
        }
    }

    func getConversations(for userID: String, completion: @escaping ([Conversation]) -> Void) {
        getAllConversations { allConversations in
            let userConversations = allConversations[userID] ?? []
            completion(userConversations)
        }
    }
    
    func getAllConversations(completion: @escaping ([String: [Conversation]]) -> Void) {
        do {
            let data = try Data(contentsOf: getFilePath())
            let allConversations = try JSONDecoder().decode([String: [Conversation]].self, from: data)
            completion(allConversations)
            print("All conversations loaded successfully.")
        } catch {
            print("Failed to load conversations: \(error.localizedDescription)")
            completion([:])
        }
    }

    func deleteConversation(at indexPath: IndexPath, for userID: String, completion: @escaping (Bool) -> Void) {
        getConversations(for: userID) { [weak self] conversations in
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
            self.saveConversations(data: updatedConversations, for: userID)
            completion(true)
        }
    }
}

