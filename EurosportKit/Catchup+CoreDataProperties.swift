//
//  Catchup+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension Catchup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catchup> {
        return NSFetchRequest<Catchup>(entityName: "Catchup")
    }

    @NSManaged public var catchupDescription: String
    @NSManaged public var duration: TimeInterval
    @NSManaged public var expirationDate: Date?
    @NSManaged public var identifier: Int32
    @NSManaged public var imageURL: URL
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String
    @NSManaged public var sport: Sport
    @NSManaged public var streams: NSOrderedSet

}

// MARK: Generated accessors for streams
extension Catchup {

    @objc(insertObject:inStreamsAtIndex:)
    @NSManaged public func insertIntoStreams(_ value: CatchupStream, at idx: Int)

    @objc(removeObjectFromStreamsAtIndex:)
    @NSManaged public func removeFromStreams(at idx: Int)

    @objc(insertStreams:atIndexes:)
    @NSManaged public func insertIntoStreams(_ values: [CatchupStream], at indexes: NSIndexSet)

    @objc(removeStreamsAtIndexes:)
    @NSManaged public func removeFromStreams(at indexes: NSIndexSet)

    @objc(replaceObjectInStreamsAtIndex:withObject:)
    @NSManaged public func replaceStreams(at idx: Int, with value: CatchupStream)

    @objc(replaceStreamsAtIndexes:withStreams:)
    @NSManaged public func replaceStreams(at indexes: NSIndexSet, with values: [CatchupStream])

    @objc(addStreamsObject:)
    @NSManaged public func addToStreams(_ value: CatchupStream)

    @objc(removeStreamsObject:)
    @NSManaged public func removeFromStreams(_ value: CatchupStream)

    @objc(addStreams:)
    @NSManaged public func addToStreams(_ values: NSOrderedSet)

    @objc(removeStreams:)
    @NSManaged public func removeFromStreams(_ values: NSOrderedSet)

}
