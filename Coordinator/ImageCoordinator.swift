//
//  ImageCoordinator.swift
//  AI
//
//  Created by Chichek on 27.09.24.
//

import Foundation
import UIKit

class ImageCoordinator: ImagesCoordinator {
    
    var navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start(image: UIImage, description: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageController") as! ImageController
        controller.selectedImage = image
        controller.imageDescription = description
        navigator.pushViewController(controller, animated: true)
    }
}
