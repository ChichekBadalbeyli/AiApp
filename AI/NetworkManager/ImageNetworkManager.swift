//
//  ImageNetworkManager.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//


import Foundation
import Alamofire
import UIKit

class ImageNetworkManager {
    
    static func encodeImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    static func requestImageEdit(with image: UIImage, prompt: String, completion: @escaping (String?, Error?) -> Void) {
        guard let base64Image = encodeImageToBase64(image) else {
            completion(nil, NSError(domain: "ImageEncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image to Base64."]))
            return
        }
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(NetworkConstants.apiKey)", forHTTPHeaderField: "Authorization")
        let payload: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
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
        print("Payload: \(payload)")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            completion(nil, error)
            return
        }
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let data):
                if let rawString = String(data: data, encoding: .utf8) {
                    print("Raw Response String: \(rawString)")
                }
                do {
                    let jsonResponse = try JSONDecoder().decode(ImageChatResponse.self, from: data)
                    if let content = jsonResponse.choices.first?.message.content {
                        completion(content, nil)
                    } else {
                        completion(nil, NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response content found"]))
                    }
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            case .failure(let error):
                print("Network request failed: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}
