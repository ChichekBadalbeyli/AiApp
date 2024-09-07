//
//  HistoryViewController.swift
//  AI
//
//  Created by Chichek on 08.08.24.
//

import UIKit
import Alamofire
import FirebaseAuth

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var viewModel = HistoryViewModel()
    
    @IBOutlet weak var conversationSearchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var filteredConversations:[Conversation] = []
    var isSearchingg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: "MessageViewCell", bundle: nil),
                       forCellReuseIdentifier: "MessageViewCell")
        table.dataSource = self
        table.delegate = self
        viewModel.savedConversations {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        loadUserConversations()
        conversationSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserConversations()
    }
    
    func loadUserConversations() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        viewModel.savedConversations {
            DispatchQueue.main.async {
                self.viewModel.conversations = self.viewModel.conversations.filter { $0.user_id == user.uid }
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchingg ? filteredConversations.count : viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        let conversation = isSearchingg ? filteredConversations[indexPath.row] : viewModel.conversations[indexPath.row]
        if let firstUserMessage = conversation.messages.first {
            cell.configure(with: firstUserMessage, isPinned: conversation.pinned)
            cell.messageLabel.textAlignment = .left
            cell.messageLabel.backgroundColor = .white
            cell.pin.backgroundColor = .white
        }
        
        cell.pinAction = { [weak self] in
            self?.togglePin(for: conversation)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let conversation = viewModel.conversations[indexPath.row]
        
        let pinAction = UIContextualAction(style: .normal, title: conversation.pinned ? "Unpin" : "Pin") { [weak self] (action, view, completionHandler) in
            self?.togglePin(for: conversation)
            completionHandler(true)
        }
        pinAction.backgroundColor = .systemBlue
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.viewModel.conversations.remove(at: indexPath.row)
            self?.viewModel.saveConversation()
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, pinAction])
    }
    
    func togglePin(for conversation: Conversation) {
        if let index = viewModel.conversations.firstIndex(where: { $0.id == conversation.id }) {
            viewModel.conversations[index].pinned.toggle()
            viewModel.saveConversation()
            viewModel.sortConversations()
            table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedConversation = viewModel.conversations[indexPath.row]
        viewModel.setConversation(selectedConversation)
        viewModel.saveConversation()
        if let chatViewController = navigationController?.viewControllers.first(where: { $0 is ChatViewController }) as? ChatViewController {
            chatViewController.viewModel.currentConversation = selectedConversation
            chatViewController.table.reloadData()
            navigationController?.popViewController(animated: true)
            UserDefaults.standard.set(selectedConversation.id.uuidString, forKey: "lastViewedConversationID")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        signOut()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = scene.delegate as? SceneDelegate {
                sceneDelegate.setLoginAsRoot()
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchingg = false
            filteredConversations.removeAll()
        } else {
            isSearchingg = true
            filteredConversations = viewModel.conversations.filter{ conversation in
                conversation.messages.contains { $0.content.lowercased().contains(searchText.lowercased()) }
            }
        }
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchingg = false
        searchBar.text = ""
        table.reloadData()
        searchBar.resignFirstResponder()
    }
    
    @IBAction func newPage(_ sender: Any) {
        let coordinator = ChatCoordinator(navigator: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let coordinator = ProfileCoordinator(navigator: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
    
}


