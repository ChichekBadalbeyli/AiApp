//
//  ImageManager.swift
//  AI
//
//  Created by Chichek on 24.09.24.
//

import UIKit
import Foundation
import Alamofire

protocol ImageManagerProtocol {
    func processImage(image: UIImage, prompt: String, completion: @escaping (String?, String?) -> Void)
}

class ImageManager: ImageManagerProtocol {
    
    func processImage(image: UIImage, prompt: String, completion: @escaping (String?, String?) -> Void) {
        let endpoint = ChatEndpoint.chatEndpoint.rawValue
        ImageNetworkManager.requestImageEdit(with: image, prompt: prompt, endpoint: endpoint) { description, error in
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
