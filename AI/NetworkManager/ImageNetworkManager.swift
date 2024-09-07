//
//  ImageNetworkManager.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//


import Foundation
import UIKit

class ImageNetworkManager {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var apiKey = " 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"
    
    func sendImageRequest(with image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Convert the UIImage to Base64 string
        guard let base64Image = encodeImageToBase64(image) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image to base64"])))
            return
        }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
     
        
        let payload: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "What’s in this image?"
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 300
        ]
    }
    
    private func encodeImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
}
