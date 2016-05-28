//
//  UserParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct UserParser : JSONCoreDataParsingType {
    
    typealias T = User
    
    enum UserError : ErrorType {
        case MissingIdentifier
        case MissingHkey
    }
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: String = try json.extract("Id")
        let hkey: String = try json.extract("Hkey")
        let email: String = try json.extract("Email")
        
        guard let user = try User.object(withIdentifier: identifier, inContext: context) else {
            throw JSONCoreDataError.UnableToCreateInstance
        }
        
        user.hkey = hkey
        user.email = email
        return user
        
    }
        
}
    