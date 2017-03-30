//
//  User.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/01/2017.


import Foundation
import CoreData

extension User: StringIdentifiable { }
extension User: Fetchable {

    public static var entityName: String {
        return "User"
    }
}

extension User {

    public static func currentUser(_ context: NSManagedObjectContext) -> User? {
        do {
            return try singleObject(in: context, predicate: nil, sortedBy: nil, ascending: true)
        } catch {
            return nil
        }
    }

}
