//
//  ProfileCoordinator.swift
//  AI
//
//  Created by Chichek on 07.09.24.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    
    var navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        navigator.show(controller, sender: nil)
    }
}
