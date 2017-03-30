//
//  JSONParsingType.swift
//  EurosportKit
//

import Foundation

internal protocol JSONParsingType {
    associatedtype T
    static func parse(_ json: JSONObject) throws -> T
    static func parse(_ json: JSONArray) -> [T]
}

extension JSONParsingType {
    static func parse(_ json: JSONArray) -> [T] {
        return json.flatMap {
            do {
                return try parse($0)
            } catch {
                print("\(self) parse error: \(error)")
                return nil
            }
        }
    }
}
