//
//  UserParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

internal struct UserParser : JSONParsingType {
    
    typealias T = User
    
    enum UserError : ErrorType {
        case MissingIdentifier
        case MissingHkey
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
        let identifier: String = try json.extract("Id")
        let hkey: String = try json.extract("Hkey")
        return User(identifier: identifier, hkey: hkey)
    }
        
}
    