//
//  TokenResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

struct TokenResponseSerializer {
    typealias T = Token
    
    enum TokenError: ErrorType {
        case InvalidJSONStructure
    }
    
    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, response, error in
            
            guard let json = try VideoshopResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [String: AnyObject] else {
                throw TokenError.InvalidJSONStructure
            }
            
            return try TokenParser.parse(json)
        }
    }
    
}