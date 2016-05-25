// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Sport.swift instead.

import Foundation
import CoreData

public enum SportAttributes: String {
    case identifier = "identifier"
    case imageURL = "imageURL"
    case name = "name"
}

public enum SportRelationships: String {
    case catchups = "catchups"
}

public enum SportFetchedProperties: String {
    case fetchedProperty = "fetchedProperty"
}

public class _Sport: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Sport"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Sport.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var identifier: NSNumber

    @NSManaged public
    var imageURLString: String

    @NSManaged public
    var name: String

    // MARK: - Relationships

    @NSManaged public
    var catchups: NSSet

    @NSManaged public
    var fetchedProperty: [Sport]

}

extension _Sport {

    func addCatchups(objects: NSSet) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.catchups = mutable.copy() as! NSSet
    }

    func removeCatchups(objects: NSSet) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.catchups = mutable.copy() as! NSSet
    }

    func addCatchupsObject(value: Catchup) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.catchups = mutable.copy() as! NSSet
    }

    func removeCatchupsObject(value: Catchup) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.catchups = mutable.copy() as! NSSet
    }

}

