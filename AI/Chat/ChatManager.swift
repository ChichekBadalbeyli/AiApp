//
//  ChatManager.swift
//  AI
//
//  Created by Chichek on 01.08.24.
//

import Foundation
import Alamofire

protocol MovieManagerProtocol {
    func getChat (endpoint:ChatEndpoint, parameters: Parameters, completion: @escaping((Welcome?,String?)-> Void))
}

class ChatManager: MovieManagerProtocol {
    func getChat(endpoint: ChatEndpoint, parameters: Parameters, completion: @escaping ((Welcome?, String?) -> Void)) {
        NetworkManager.request(model: Welcome.self, endpoint: endpoint.rawValue, parameters: parameters, completion: completion)
    }
}
