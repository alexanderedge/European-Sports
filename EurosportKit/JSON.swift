//
//  JSONType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

enum JSONError: Error {
    case missingKey(StringProtocol)
}

protocol StringProtocol {}

extension String: StringProtocol {}

extension Dictionary where Key: StringProtocol {
    
    func extract<ReturnType>(_ key: Key) throws -> ReturnType {
        guard let value = self[key] as? ReturnType else {
            throw JSONError.missingKey(key)
        }
        return value
    }
    
}
