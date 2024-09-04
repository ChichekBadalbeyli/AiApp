//
//  ViewController.swift
//  AI
//
//  Created by Chichek on 25.07.24.
//

import UIKit
import Alamofire
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var questionTextField: UITextView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var viewModel = ChatModelController()
    var viewController = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewController = self
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "MessageViewCell")
        table.rowHeight = UITableView.automaticDimension
        questionTextField.delegate = self
        questionTextField.layer.borderColor = UIColor.black.cgColor
        questionTextField.layer.borderWidth = 1.0
        questionTextField.layer.cornerRadius = 10
        DispatchQueue.main.async {
            self.table.reloadData()
            self.viewModel.scrollToBottom()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadConversation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    @IBAction func tappedButtonAction(_ sender: Any) {
        guard let question = questionTextField.text, !question.isEmpty else {
            return
        }
        viewModel.getChatDatas(prompt: question)
        questionTextField.text = ""
    }
    
    @IBAction func newConversation(_ sender: Any) {
        viewModel.startNewConversation()
    }
    
    @IBAction func historyController(_ sender: Any) {
        let coordinator = HistoryCoordinator(navigator: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentConversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        let message = viewModel.currentConversation.messages[indexPath.row]
        cell.pin.isHidden = true
        cell.configure(with: message, isPinned: Bool())
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.currentConversation.messages.remove(at: indexPath.row)
            if let currentUser = Auth.auth().currentUser {
                viewModel.saveConversations(for: currentUser)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
