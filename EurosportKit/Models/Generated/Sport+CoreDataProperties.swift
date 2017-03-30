//
//  Sport+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension Sport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sport> {
        return NSFetchRequest<Sport>(entityName: "Sport")
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var imageURL: URL?
    @NSManaged public var name: String
    @NSManaged public var catchups: NSSet
    @NSManaged public var scheduledProgrammes: NSSet

}

// MARK: Generated accessors for catchups
extension Sport {

    @objc(addCatchupsObject:)
    @NSManaged public func addToCatchups(_ value: Catchup)

    @objc(removeCatchupsObject:)
    @NSManaged public func removeFromCatchups(_ value: Catchup)

    @objc(addCatchups:)
    @NSManaged public func addToCatchups(_ values: NSSet)

    @objc(removeCatchups:)
    @NSManaged public func removeFromCatchups(_ values: NSSet)

}

// MARK: Generated accessors for scheduledProgrammes
extension Sport {

    @objc(addScheduledProgrammesObject:)
    @NSManaged public func addToScheduledProgrammes(_ value: ScheduledProgramme)

    @objc(removeScheduledProgrammesObject:)
    @NSManaged public func removeFromScheduledProgrammes(_ value: ScheduledProgramme)

    @objc(addScheduledProgrammes:)
    @NSManaged public func addToScheduledProgrammes(_ values: NSSet)

    @objc(removeScheduledProgrammes:)
    @NSManaged public func removeFromScheduledProgrammes(_ values: NSSet)

}
