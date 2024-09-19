//
//  ImageNetworkManager.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//


import Foundation
import UIKit

class ImageNetworkManager {
    let url = URL(string: "https://api.openai.com/v1/images/edits")!
    var apiKey = " sk-y_QFgeQBS7q0j4OoXrBxZSDo_B-rsl4-K1Jvw2kv_7T3BlbkFJczhM5P8vRAQfajCCZ0lKSmaeozN_QJwh6jPJvqwakA"
    
    func sendImageRequest(with image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
          guard let base64Image = encodeImageToBase64(image) else {
              completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image to base64"])))
              return
          }
          let payload: [String: Any] = [
              "model": "image-alpha-001",
              "prompt": "Describe this image",
              "image": base64Image,
              "num_images": 1
          ]
          guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
              completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create JSON payload"])))
              return
          }
          request.httpBody = httpBody

          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                  print("Request failed with error: \(error.localizedDescription)")
                  completion(.failure(error))
                  return
              }
              
              guard let data = data else {
                  print("No data received")
                  completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                  return
              }

              if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                  print("Response JSON: \(responseJSON)")
                  if let description = responseJSON["description"] as? String {
                      completion(.success(description))
                  } else {
                      completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Description not found in response"])))
                  }
              } else {
                  completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])))
              }
          }
          
          task.resume()
      }
      
      private func encodeImageToBase64(_ image: UIImage) -> String? {
          guard let imageData = image.jpegData(compressionQuality: 0.8) else {
              return nil
          }
          return imageData.base64EncodedString()
      }
  }
