//
//  NetworkManager.swift
//  AI
//
//  Created by Chichek on 25.07.24.
//
import Foundation
import Alamofire

class NetworkManager {
    static func request<T: Codable>(model: T.Type,
                                    endpoint: String,
                                    method: HTTPMethod = .post,
                                    parameters: Parameters? = nil,
                                    encoding: ParameterEncoding = JSONEncoding.default,
                                    completion: @escaping ((T?, String?) -> Void)) {
        AF.request(NetworkConstants.getUrl(with: endpoint),
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: NetworkConstants.getHeaders()).responseDecodable(of: T .self) { response in
            switch response.result {
            case.success (let data):
                completion(data, nil)
            case.failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
