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
    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, response, error in
            return try TokenParser.parse(try VideoshopResponseSerializer.serializer().serializeResponse(data, response: response, error: error))
        }
    }
    
}