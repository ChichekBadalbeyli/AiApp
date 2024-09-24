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
        
        // Convert the image to Base64
        static func encodeImageToBase64(_ image: UIImage) -> String? {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
        
        // Send a request to process the image
        static func requestImageEdit(with image: UIImage, prompt: String, endpoint: String, completion: @escaping (String?, Error?) -> Void) {
            guard let base64Image = encodeImageToBase64(image) else {
                completion(nil, NSError(domain: "ImageEncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image to Base64."]))
                return
            }

            let url = URL(string: NetworkConstants.getUrl(with: endpoint))!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(NetworkConstants.header["Authorization"]!)", forHTTPHeaderField: "Authorization")
            
            let payload: [String: Any] = [
                "model": "gpt-4o",
                "messages": [
                    [
                        "role": "user",
                        "content": "What’s in this image: data:image/jpeg;base64,\(base64Image)"
                    ]
                ],
                "max_tokens": 300
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
                request.httpBody = jsonData
            } catch {
                completion(nil, error)
                return
            }
            
            // Make the request using Alamofire
            AF.request(request).responseData { response in
                switch response.result {
                case .success(let data):
                    // Print raw response for debugging
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Raw JSON Response: \(json)")
                        
                        // Now attempt to parse the response
                        if let choices = json["choices"] as? [[String: Any]],
                           let message = choices.first?["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            completion(content, nil)
                        } else {
                            print("Error: Response structure doesn't match.")
                            completion(nil, NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response structure"]))
                        }
                    } else {
                        print("Error: Could not decode JSON.")
                        completion(nil, NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"]))
                    }
                case .failure(let error):
                    print("Network request failed: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }


//    static func encodeImageToBase64(_ image: UIImage) -> String? {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
//        return imageData.base64EncodedString(options: .lineLength64Characters)
//    }
//    
//    static func requestImageEdit(with image: UIImage, prompt: String, endpoint: String, completion: @escaping (String?, Error?) -> Void) {
//        guard let base64Image = encodeImageToBase64(image) else {
//            completion(nil, NSError(domain: "ImageEncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image to Base64."]))
//            return
//        }
//
//        var url = URL(string: NetworkConstants.getUrl(with: endpoint))
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(NetworkConstants.header["Authorization"]!)", forHTTPHeaderField: "Authorization")
//        
//        let payload: [String: Any] = [
//            "model": "gpt-4o",
//            "messages": [
//                [
//                    "role": "user",
//                    "content": "What’s in this image: data:image/jpeg;base64,\(base64Image)"
//                ]
//            ],
//            "max_tokens": 300
//        ]
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
//            request.httpBody = jsonData
//        } catch {
//            completion(nil, error)
//            return
//        }
//        
//        AF.request(request).responseData { response in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let choices = json["choices"] as? [[String: Any]],
//                   let message = choices.first?["message"] as? [String: Any],
//                   let content = message["content"] as? String {
//                    completion(content, nil)
//                } else {
//                    completion(nil, NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"]))
//                }
//            case .failure(let error):
//                completion(nil, error)
//            }
//        }
//    }







//import Foundation
//import Alamofire
//import UIKit
//
//class ImageNetworkManager {
//    static func sendImageRequest(with image: UIImage, completion: @escaping ((String?, String?) -> Void)) {
//        let endpoint = "v1/images/edits"
//        let parameters: [String: Any] = [
//            "model": "image-alpha-001",
//            "prompt": "Describe this image",
//            "image": encodeImageToBase64(image) ?? "",
//            "num_images": 1
//        ]
//
//        NetworkManager.request(model: ImageResponse.self, endpoint: endpoint, parameters: parameters) { response, error in
//            if let response = response, let description = response.description {
//                completion(description, nil)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
//
//    static func encodeImageToBase64(_ image: UIImage) -> String? {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            return nil
//        }
//        return imageData.base64EncodedString()
//    }
//}
//
//struct ImageResponse: Codable {
//    let description: String?
//}
//
//
//
//
//class ImageNetworkManager {
//    let url = URL(string: "https://api.openai.com/v1/images/edits")!
//    var apiKey = " sk-y_QFgeQBS7q0j4OoXrBxZSDo_B-rsl4-K1Jvw2kv_7T3BlbkFJczhM5P8vRAQfajCCZ0lKSmaeozN_QJwh6jPJvqwakA"
//
//    func sendImageRequest(with image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        var request = URLRequest(url: url)
//          request.httpMethod = "POST"
//          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//          request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//          guard let base64Image = encodeImageToBase64(image) else {
//              completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image to base64"])))
//              return
//          }
//          let payload: [String: Any] = [
//              "model": "image-alpha-001",
//              "prompt": "Describe this image",
//              "image": base64Image,
//              "num_images": 1
//          ]
//          guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
//              completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create JSON payload"])))
//              return
//          }
//          request.httpBody = httpBody
//
//          let task = URLSession.shared.dataTask(with: request) { data, response, error in
//              if let error = error {
//                  print("Request failed with error: \(error.localizedDescription)")
//                  completion(.failure(error))
//                  return
//              }
//
//              guard let data = data else {
//                  print("No data received")
//                  completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                  return
//              }
//
//              if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                  print("Response JSON: \(responseJSON)")
//                  if let description = responseJSON["description"] as? String {
//                      completion(.success(description))
//                  } else {
//                      completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Description not found in response"])))
//                  }
//              } else {
//                  completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])))
//              }
//          }
//
//          task.resume()
//      }
//
//      private func encodeImageToBase64(_ image: UIImage) -> String? {
//          guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//              return nil
//          }
//          return imageData.base64EncodedString()
//      }
//  }

