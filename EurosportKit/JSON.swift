//
//  JSON.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation

typealias JSON = Any
typealias JSONObject = [String: JSON]
typealias JSONArray = [JSONObject]

enum JSONError: LocalizedError, CustomNSError {
    case missingData
    case missingKey(String)
    case invalidStructure(Any, Any)

    public var errorDescription: String? {
        switch self {
        case .missingKey(let key):
            return NSLocalizedString("Missing key: \(key)", comment: "")
        case .missingData:
            return NSLocalizedString("Missing Data", comment: "")
        case .invalidStructure(let expected, let found):
            return  NSLocalizedString("Invalid JSON Structure: expected \(expected) found \(found)", comment: "")
        }
    }

    var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: errorDescription!]
    }

}

extension Dictionary where Key == String {

    func extract<ReturnType>(_ key: Key) throws -> ReturnType {
        guard let value = self[key] as? ReturnType else {
            throw JSONError.missingKey(key)
        }
        return value
    }

    func optionalExtract<ReturnType>(_ key: Key) -> ReturnType? {
        guard let value = self[key] as? ReturnType else {
            return nil
        }
        return value
    }

}
