//
//  JSONType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

enum JSONError: ErrorType {
    case MissingKey(StringProtocol)
}

protocol StringProtocol {}

extension String: StringProtocol {}

extension Dictionary where Key: StringProtocol {
    
    func extract<ReturnType>(key: Key) throws -> ReturnType {
        guard let value = self[key] as? ReturnType else {
            throw JSONError.MissingKey(key)
        }
        return value
    }
    
}