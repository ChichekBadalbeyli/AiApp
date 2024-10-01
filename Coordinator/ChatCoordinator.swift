//
//  ChatCoordinator.swift
//  AI
//
//  Created by Chichek on 28.08.24.
//

import Foundation
import UIKit

class ChatCoordinator: ChatCoordinatorProtocol{

    
    var navigator: UINavigationController
    
    init (navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start(with conversation: Conversation) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.viewModel.currentConversation = conversation
        navigator.pushViewController(controller, animated: true)
    }
}
