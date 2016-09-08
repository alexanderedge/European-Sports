//
//  VideoshopResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

struct VideoshopResponseSerializer {
    
    typealias T = Any
    
    enum VideoshopError: Error {
        case invalidJSONStructure
    }
    
    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, response, error in
            guard let json = try JSONResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [String: Any] else {
                throw VideoshopError.invalidJSONStructure
            }
            return try json.extract("PlayerObj")
        }
    }
    
}
