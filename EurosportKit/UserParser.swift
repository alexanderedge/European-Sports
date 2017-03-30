//
//  UserParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation
import CoreData

internal struct UserParser: JSONCoreDataParsingType {

    typealias T = User

    enum UserError: Error {
        case missingIdentifier
        case missingHkey
    }

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: String = try json.extract("Id")
        let hkey: String = try json.extract("Hkey")
        let email: String = try json.extract("Email")
        let user = try User.newOrExistingObject(identifier, inContext: context)
        user.hkey = hkey
        user.email = email
        return user

    }

}
