//
//  ImagesCoordinatorProtocol.swift
//  AI
//
//  Created by Chichek on 27.09.24.
//

import Foundation
import UIKit

protocol ImagesCoordinator {
    var navigator: UINavigationController {get set}
    func start(image: UIImage, description: String)
}
