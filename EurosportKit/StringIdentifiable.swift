//
//  StringIdentifierType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

public protocol StringIdentifiable {
    var identifier: String { get set }
}

extension Fetchable where Self: NSManagedObject, Self: StringIdentifiable, FetchableType == Self {
    
    public static func existingObject(identifier: String, inContext context: NSManagedObjectContext) throws -> FetchableType? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return try singleObjectInContext(context, predicate: predicate, sortedBy: nil, ascending: true)
    }
    
    public static func newOrExistingObject(identifier: String, inContext context: NSManagedObjectContext) throws -> FetchableType {
        
        if let existingObject = try existingObject(identifier, inContext: context) {
            return existingObject
        }
        
        var newObject = Self(context: context)
        newObject.identifier = identifier
        return newObject
    }
    
}