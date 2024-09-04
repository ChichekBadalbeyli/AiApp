//
//  RegisterCoordinator.swift
//  AI
//
//  Created by Chichek on 23.08.24.
//

import UIKit

class RegisterCoordinator: Coordinator {
    
    var navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigator.show(controller, sender: nil)
    }
}
