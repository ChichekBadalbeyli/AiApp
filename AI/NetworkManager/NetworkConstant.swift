//
//  NetworkConstant.swift
//  AI
//
//  Created by Chichek on 25.07.24.
//

import Foundation
import Alamofire
//import OpenAI

class NetworkConstants {
    static let baseURL = "https://api.openai.com/v1/"
    
    static let header: HTTPHeaders = [
        "Authorization": "Bearer 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"
    ]
    static func getUrl(with endpoint: String) -> String {
        return baseURL + endpoint
    }
}

