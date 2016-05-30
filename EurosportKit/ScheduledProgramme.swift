//
//  SheduledProgramme.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(ScheduledProgramme)
public class ScheduledProgramme: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public
    var identifier: NSNumber
    
    @NSManaged public
    var name: String
    
    @NSManaged public
    var startDate: NSDate
    
    @NSManaged public
    var endDate: NSDate
    
    @NSManaged public
    var imageURL: NSURL
        
    @NSManaged public
    var competitionName: NSString?
    
    @NSManaged public
    var eventname: NSString?
    
    // MARK: - Relationships
    
    @NSManaged public
    var sport: Sport
    
    @NSManaged public
    var product: Product
    
}

extension ScheduledProgramme: NumberIdentifiable { }

extension ScheduledProgramme: Fetchable {
    
    public typealias FetchableType = ScheduledProgramme
    
    public static func entityName() -> String {
        return "ScheduledProgramme"
    }
    
}
