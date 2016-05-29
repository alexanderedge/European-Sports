//
//  VideoshopResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

struct VideoshopResponseSerializer {
    
    typealias T = AnyObject
    
    enum VideoshopError: ErrorType {
        case InvalidJSONStructure
    }
    
    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, response, error in
            guard let json = try JSONResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [String: AnyObject] else {
                throw VideoshopError.InvalidJSONStructure
            }
            return try json.extract("PlayerObj")
        }
    }
    
}