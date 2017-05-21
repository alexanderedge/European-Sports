//
//  JSONResponseSerializer.swift
//  EurosportPlayer
//

import Foundation

class JSONResponseSerializer<T>: ResponseSerializer<T> {

    override func serializeResponse(_ data: Data?, response: URLResponse?, error: Error?) throws -> T {
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
