//
//  JSONResponseSerializer.swift
//  EurosportPlayer
//

import Foundation

struct JSONResponseSerializer <T> {

    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, _, error in
            if let data = data {
                let parsed = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard let value = parsed as? T else {
                    throw JSONError.invalidStructure(type(of: parsed), T.self)
                }
                return value
            } else if let error = error {
                throw error
            } else {
                throw JSONError.missingData
            }
        }
    }

}
