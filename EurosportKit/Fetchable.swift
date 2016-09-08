//
//  Fetchable.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 24/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

// https://gist.github.com/capttaco/adb38e0d37fbaf9c004e
public protocol Fetchable  {
    associatedtype FetchableType: NSManagedObject
    
    static var entityName: String { get }
    static func entity(_ managedObjectContext: NSManagedObjectContext) -> NSEntityDescription?
    static func objectsInContext(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) throws -> [FetchableType]
    static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) throws -> FetchableType?
    static func objectCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate?) throws -> Int
    static func fetchRequest(_ predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> NSFetchRequest<FetchableType>
    
}

extension Fetchable where Self: NSManagedObject, FetchableType == Self {
    
    public init(context: NSManagedObjectContext) {
        self.init(entity: Self.entity(context)!, insertInto: context)
    }
        
    public static func entity(_ managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
    }
    
    public static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) throws -> FetchableType? {
        let fr = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        fr.fetchLimit = 1
        return try context.fetch(fr).first
    }
    
    public static func objectCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Int {
        return try context.count(for: fetchRequest(predicate, sortedBy: nil))
    }
    
    public static func objectsInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) throws -> [FetchableType] {
        let fr = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        return try context.fetch(fr) 
    }
    
    public static func fetchRequest(_ predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) -> NSFetchRequest<FetchableType> {
        let fetchRequest: NSFetchRequest <FetchableType> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        if let sortedBy = sortedBy {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortedBy, ascending: ascending)]
        }
        return fetchRequest
    }
    
}
