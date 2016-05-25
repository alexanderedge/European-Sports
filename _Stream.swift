// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stream.swift instead.

import Foundation
import CoreData

public enum StreamAttributes: String {
    case identifier = "identifier"
    case urlString = "urlString"
}

public enum StreamRelationships: String {
    case catchup = "catchup"
}

public class _Stream: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Stream"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Stream.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var identifier: NSNumber?

    @NSManaged public
    var urlString: String

    // MARK: - Relationships

    @NSManaged public
    var catchup: Catchup?

}

