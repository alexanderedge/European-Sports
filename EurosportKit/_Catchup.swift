// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Catchup.swift instead.

import Foundation
import CoreData

public enum CatchupAttributes: String {
    case identifier = "identifier"
    case title = "title"
}

public enum CatchupRelationships: String {
    case sport = "sport"
    case streams = "streams"
}

public class _Catchup: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Catchup"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Catchup.entity(managedObjectContext) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var identifier: NSNumber

    @NSManaged public
    var title: String

    // MARK: - Relationships

    @NSManaged public
    var sport: Sport?

    @NSManaged public
    var streams: NSSet

}

extension _Catchup {

    func addStreams(objects: NSSet) {
        let mutable = self.streams.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.streams = mutable.copy() as! NSSet
    }

    func removeStreams(objects: NSSet) {
        let mutable = self.streams.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.streams = mutable.copy() as! NSSet
    }

    func addStreamsObject(value: Stream) {
        let mutable = self.streams.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.streams = mutable.copy() as! NSSet
    }

    func removeStreamsObject(value: Stream) {
        let mutable = self.streams.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.streams = mutable.copy() as! NSSet
    }

}

