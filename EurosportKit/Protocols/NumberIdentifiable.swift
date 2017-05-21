//
//  NumberIdentifiable.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.

import Foundation
import CoreData

@objc public protocol Int32Identifiable {
    var identifier: Int32 { get set }
}

extension Fetchable where Self: NSManagedObject, Self: Int32Identifiable, FetchableType == Self {

    public static func existingObject(_ identifier: Int32, inContext context: NSManagedObjectContext) throws -> FetchableType? {
        let predicate = NSPredicate(format: "identifier == %d", identifier)
        return try singleObject(in: context, predicate: predicate, sortedBy: nil, ascending: true)
    }

    public static func newOrExistingObject(_ identifier: Int32, inContext context: NSManagedObjectContext) throws -> FetchableType {

        if let existingObject = try existingObject(identifier, inContext: context) {
            return existingObject
        }

        let newObject = Self(context: context)
        newObject.identifier = identifier
        return newObject
    }

}
