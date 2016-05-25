//
//  Fetchable.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 24/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

public protocol Fetchable  {
    associatedtype FetchableType: NSManagedObject
    
    static func entityName() -> String
    static func objectsInContext(context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) throws -> [FetchableType]
    static func singleObjectInContext(context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) throws -> FetchableType?
    static func objectCountInContext(context: NSManagedObjectContext, predicate: NSPredicate?) -> Int
    static func fetchRequest(predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> NSFetchRequest
    
}

extension Fetchable where Self : NSManagedObject, FetchableType == Self {
    
    public static func singleObjectInContext(context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) throws -> FetchableType? {
        let fr = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        fr.fetchLimit = 1
        return try context.executeFetchRequest(fr).first as? FetchableType
    }
    
    public static func objectCountInContext(context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int {
        let error: NSErrorPointer = nil;
        let count = context.countForFetchRequest(fetchRequest(predicate, sortedBy: nil), error: error)
        guard error == nil else {
            print("error fetching count: \(error)")
            return 0;
        }
        return count
    }
    
    public static func objectsInContext(context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) throws -> [FetchableType] {
        let fr = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        return try context.executeFetchRequest(fr) as! [FetchableType]
    }
    
    public static func fetchRequest(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        fetchRequest.predicate = predicate
        if let sortedBy = sortedBy {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortedBy, ascending: ascending)]
        }
        return fetchRequest
    }
    
}