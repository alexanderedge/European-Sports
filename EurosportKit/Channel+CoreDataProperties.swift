//
//  Channel+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension Channel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Channel> {
        return NSFetchRequest<Channel>(entityName: "Channel")
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var logoURL: URL?
    @NSManaged public var title: String
    @NSManaged public var subtitle: String
    @NSManaged public var liveStreams: NSOrderedSet
    @NSManaged public var scheduledProgrammes: NSOrderedSet

}

// MARK: Generated accessors for liveStreams
extension Channel {

    @objc(insertObject:inLiveStreamsAtIndex:)
    @NSManaged public func insertIntoLiveStreams(_ value: LiveStream, at idx: Int)

    @objc(removeObjectFromLiveStreamsAtIndex:)
    @NSManaged public func removeFromLiveStreams(at idx: Int)

    @objc(insertLiveStreams:atIndexes:)
    @NSManaged public func insertIntoLiveStreams(_ values: [LiveStream], at indexes: NSIndexSet)

    @objc(removeLiveStreamsAtIndexes:)
    @NSManaged public func removeFromLiveStreams(at indexes: NSIndexSet)

    @objc(replaceObjectInLiveStreamsAtIndex:withObject:)
    @NSManaged public func replaceLiveStreams(at idx: Int, with value: LiveStream)

    @objc(replaceLiveStreamsAtIndexes:withLiveStreams:)
    @NSManaged public func replaceLiveStreams(at indexes: NSIndexSet, with values: [LiveStream])

    @objc(addLiveStreamsObject:)
    @NSManaged public func addToLiveStreams(_ value: LiveStream)

    @objc(removeLiveStreamsObject:)
    @NSManaged public func removeFromLiveStreams(_ value: LiveStream)

    @objc(addLiveStreams:)
    @NSManaged public func addToLiveStreams(_ values: NSOrderedSet)

    @objc(removeLiveStreams:)
    @NSManaged public func removeFromLiveStreams(_ values: NSOrderedSet)

}

// MARK: Generated accessors for scheduledProgrammes
extension Channel {

    @objc(insertObject:inScheduledProgrammesAtIndex:)
    @NSManaged public func insertIntoScheduledProgrammes(_ value: ScheduledProgramme, at idx: Int)

    @objc(removeObjectFromScheduledProgrammesAtIndex:)
    @NSManaged public func removeFromScheduledProgrammes(at idx: Int)

    @objc(insertScheduledProgrammes:atIndexes:)
    @NSManaged public func insertIntoScheduledProgrammes(_ values: [ScheduledProgramme], at indexes: NSIndexSet)

    @objc(removeScheduledProgrammesAtIndexes:)
    @NSManaged public func removeFromScheduledProgrammes(at indexes: NSIndexSet)

    @objc(replaceObjectInScheduledProgrammesAtIndex:withObject:)
    @NSManaged public func replaceScheduledProgrammes(at idx: Int, with value: ScheduledProgramme)

    @objc(replaceScheduledProgrammesAtIndexes:withScheduledProgrammes:)
    @NSManaged public func replaceScheduledProgrammes(at indexes: NSIndexSet, with values: [ScheduledProgramme])

    @objc(addScheduledProgrammesObject:)
    @NSManaged public func addToScheduledProgrammes(_ value: ScheduledProgramme)

    @objc(removeScheduledProgrammesObject:)
    @NSManaged public func removeFromScheduledProgrammes(_ value: ScheduledProgramme)

    @objc(addScheduledProgrammes:)
    @NSManaged public func addToScheduledProgrammes(_ values: NSOrderedSet)

    @objc(removeScheduledProgrammes:)
    @NSManaged public func removeFromScheduledProgrammes(_ values: NSOrderedSet)

}
