//
//  NetworkConstant.swift
//  AI
//
//  Created by Chichek on 25.07.24.
//


import Foundation
import Alamofire

class NetworkConstants {
    static let baseURL = "https://api.openai.com/v1/"
    
    static let apiKey = "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"
    
    static func getHeaders() -> HTTPHeaders {
        return [
            "Authorization": "Bearer \(apiKey)",
        ]
    }
    
    static func getUrl(with endpoint: String) -> String {
        return baseURL + endpoint
    }
}

