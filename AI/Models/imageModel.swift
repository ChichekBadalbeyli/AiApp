//
//  imageModel.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//

//import Foundation
//
//// MARK: - Welcome
//struct Welcome: Codable {
//    let id, object: String
//    let created: Int
//    let model, systemFingerprint: String
//    let choices: [Choice]
//    let usage: Usage
//
//    enum CodingKeys: String, CodingKey {
//        case id, object, created, model
//        case systemFingerprint = "system_fingerprint"
//        case choices, usage
//    }
//}
//
//// MARK: - Choice
//struct Choice: Codable {
//    let index: Int
//    let message: Message
//    let logprobs: JSONNull?
//    let finishReason: String
//
//    enum CodingKeys: String, CodingKey {
//        case index, message, logprobs
//        case finishReason = "finish_reason"
//    }
//}
//
//// MARK: - Message
//struct Message: Codable {
//    let role, content: String
//}
//
//// MARK: - Usage
//struct Usage: Codable {
//    let promptTokens, completionTokens, totalTokens: Int
//    let completionTokensDetails: CompletionTokensDetails
//
//    enum CodingKeys: String, CodingKey {
//        case promptTokens = "prompt_tokens"
//        case completionTokens = "completion_tokens"
//        case totalTokens = "total_tokens"
//        case completionTokensDetails = "completion_tokens_details"
//    }
//}
//
//// MARK: - CompletionTokensDetails
//struct CompletionTokensDetails: Codable {
//    let reasoningTokens: Int
//
//    enum CodingKeys: String, CodingKey {
//        case reasoningTokens = "reasoning_tokens"
//    }
//}
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//    }
//
//    public var hashValue: Int {
//            return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//    }
//}
