//
//  CoordinnatorProtocol.swift
//  AI
//
//  Created by Chichek on 16.08.24.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigator: UINavigationController {get set}
    func start()
}
protocol ImagesCoordinator {
    var navigator: UINavigationController {get set}
    func start(image: UIImage, description: String)
}
