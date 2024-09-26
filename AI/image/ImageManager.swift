//
//  ImageManager.swift
//  AI
//
//  Created by Chichek on 24.09.24.
//


import Foundation
import UIKit

// Protocol for ImageManager to handle image processing
protocol ImageManagerProtocol {
    func processImage(image: UIImage, prompt: String, completion: @escaping (String?, String?) -> Void)
}

// Implementation of the ImageManager
class ImageManager: ImageManagerProtocol {
    func processImage(image: UIImage, prompt: String, completion: @escaping (String?, String?) -> Void) {
        ImageNetworkManager.requestImageEdit(with: image, prompt: prompt) { description, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else if let description = description {
                completion(description, nil)
            } else {
                completion(nil, "No description found.")
            }
        }
    }
}

