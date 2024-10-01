//
//  ChatCoordinatorProtocol.swift
//  AI
//
//  Created by Chichek on 30.09.24.
//

import Foundation
import UIKit
protocol ChatCoordinatorProtocol {
    var navigator: UINavigationController {get set}
    func start(with conversation: Conversation)
}
