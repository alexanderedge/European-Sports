//
//  User+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var hkey: String
    @NSManaged public var identifier: String

}
