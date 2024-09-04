//
//  ChatCoordinator.swift
//  AI
//
//  Created by Chichek on 28.08.24.
//

import Foundation
import UIKit

class ChatCoordinator: Coordinator {
    
    var navigator: UINavigationController
    
    init (navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.viewModel.startNewConversation()
        navigator.show(controller, sender: nil)
    }
    
}
