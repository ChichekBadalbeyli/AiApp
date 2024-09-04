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

