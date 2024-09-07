import Foundation
import Alamofire
import FirebaseAuth

class ChatViewModel {
    var currentConversation: Conversation
    var conversations: [Conversation] = []
    let chatManager = ChatManager()
    let fileManagerHelper = FileManagerHelp()
    let historyViewModel = HistoryViewModel()
    var viewController: ChatViewController?
    
    init() {
        self.currentConversation = Conversation(id: UUID(), messages: [], user_id: "", pinned: Bool())
        loadConversation()
    }
    
    func startNewConversation() {
        guard let user = Auth.auth().currentUser else { return }
        if !currentConversation.messages.isEmpty && !conversations.contains(where: { $0.id == currentConversation.id }) {
            conversations.append(currentConversation)
            saveConversations(for: user)
        }
        currentConversation = Conversation(id: UUID(), messages: [], user_id: user.uid, pinned: Bool())
        DispatchQueue.main.async {
            self.viewController?.table.reloadData()
        }
    }
    
    func getChatDatas(prompt: String) {
        guard let user = Auth.auth().currentUser else { return }
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        let userMessage = ChatMessage(role: "user", content: prompt, isUser: true)
        currentConversation.messages.append(userMessage)
        saveConversations(for: user)
        DispatchQueue.main.async {
            self.viewController?.table.reloadData()
            self.scrollToBottom()
        }
        chatManager.getChat(endpoint: ChatEndpoint.chatEndpoint, parameters: parameters) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response, let messageContent = response.choices.first?.message.content {
                let botMessage = ChatMessage(role: "assistant", content: messageContent, isUser: false)
                self.currentConversation.messages.append(botMessage)
                self.saveConversations(for: user)
                DispatchQueue.main.async {
                    self.viewController?.table.reloadData()
                    self.scrollToBottom()
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func scrollToBottom() {
        guard let viewController = viewController else { return }
        let numberOfRows = viewController.table.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            viewController.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func saveConversations(for user: User) {
        if !currentConversation.messages.isEmpty {
            currentConversation.user_id = user.uid
            historyViewModel.setConversation(currentConversation)
            historyViewModel.saveConversation()
        }
    }
    
    func loadConversation() {
        guard let user = Auth.auth().currentUser else { return }
        historyViewModel.savedConversations {
            DispatchQueue.main.async {
                self.conversations = self.historyViewModel.conversations.filter { $0.user_id == user.uid }
                if let lastViewedConversationID = UserDefaults.standard.string(forKey: "lastViewedConversationID"),
                   let uuid = UUID(uuidString: lastViewedConversationID),
                   let lastConversation = self.conversations.first(where: { $0.id == uuid }) {
                    self.currentConversation = lastConversation
                } else {
                    self.currentConversation = Conversation(id: UUID(), messages: [], user_id: user.uid, pinned: Bool())
                }
                self.viewController?.table.reloadData()
                self.viewController?.viewModel.scrollToBottom()
            }
        }
    }
}



