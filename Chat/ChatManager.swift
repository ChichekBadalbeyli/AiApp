//
//  ChatManager.swift
//  AI
//
//  Created by Chichek on 01.08.24.
//

import Foundation
import Alamofire

protocol ChatManagerProtocol {
    func getChat (endpoint:ChatEndpoint, parameters: Parameters, completion: @escaping((ChatStruct?,String?)-> Void))
}

class ChatManager: ChatManagerProtocol {
    func getChat(endpoint: ChatEndpoint, parameters: Parameters, completion: @escaping ((ChatStruct?, String?) -> Void)) {
        NetworkManager.request(model: ChatStruct.self, endpoint: endpoint.rawValue, parameters: parameters, completion: completion)
    }
}
