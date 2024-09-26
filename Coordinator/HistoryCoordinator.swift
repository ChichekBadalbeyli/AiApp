//
//  CoordinatorController.swift
//  AI
//
//  Created by Chichek on 16.08.24.
//

import UIKit

class HistoryCoordinator: Coordinator {
    var navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        controller.viewModel = HistoryViewModel()
        navigator.show(controller, sender: nil)
    }
}
