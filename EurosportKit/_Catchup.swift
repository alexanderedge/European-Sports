// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Catchup.swift instead.

import Foundation
import CoreData

public enum CatchupAttributes: String {
    case catchupDescription = "catchupDescription"
    case expirationDate = "expirationDate"
    case identifier = "identifier"
    case imageURL = "imageURL"
    case startDate = "startDate"
    case title = "title"
}

public enum CatchupRelationships: String {
    case sport = "sport"
    case streams = "streams"
}

public class _Catchup: NSManagedObject, NumberIdentifiable {

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
    var catchupDescription: String

    @NSManaged public
    var expirationDate: NSDate

    @NSManaged public
    var identifier: NSNumber?

    @NSManaged public
    var imageURL: AnyObject

    @NSManaged public
    var startDate: NSDate

    @NSManaged public
    var title: String

    // MARK: - Relationships

    @NSManaged public
    var sport: Sport?

    @NSManaged public
    var streams: NSOrderedSet

}

extension _Catchup {

    func addStreams(objects: NSOrderedSet) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.unionOrderedSet(objects)
        self.streams = mutable.copy() as! NSOrderedSet
    }

    func removeStreams(objects: NSOrderedSet) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.minusOrderedSet(objects)
        self.streams = mutable.copy() as! NSOrderedSet
    }

    func addStreamsObject(value: Stream) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.addObject(value)
        self.streams = mutable.copy() as! NSOrderedSet
    }

    func removeStreamsObject(value: Stream) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.removeObject(value)
        self.streams = mutable.copy() as! NSOrderedSet
    }

}

