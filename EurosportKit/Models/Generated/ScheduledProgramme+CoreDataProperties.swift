//
//  ScheduledProgramme+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension ScheduledProgramme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduledProgramme> {
        return NSFetchRequest<ScheduledProgramme>(entityName: "ScheduledProgramme")
    }

    @NSManaged public var competitionName: String?
    @NSManaged public var shortName: String?
    @NSManaged public var programmeDescription: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var eventName: String
    @NSManaged public var identifier: Int32
    @NSManaged public var imageURL: URL?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var product: Channel
    @NSManaged public var sport: Sport

}
