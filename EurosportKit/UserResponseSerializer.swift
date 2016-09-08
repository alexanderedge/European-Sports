//
//  UserResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

struct UserResponseSerializer {
    
    typealias T = User
    
    enum UserError: Error {
        case invalidJSONStructure
    }
    
    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer { context, data, response, error in
            guard let json = try JSONResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [String: AnyObject] else {
                throw UserError.invalidJSONStructure
            }
            return try UserParser.parse(json, context: context)
        }
    }
    
}
