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
open class ScheduledProgramme: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged open
    var identifier: NSNumber
    
    @NSManaged open
    var name: String
    
    @NSManaged open
    var startDate: Date
    
    @NSManaged open
    var endDate: Date
    
    @NSManaged open
    var imageURL: URL
        
    @NSManaged open
    var competitionName: NSString?
    
    @NSManaged open
    var eventname: NSString?
    
    // MARK: - Relationships
    
    @NSManaged open
    var sport: Sport
    
    @NSManaged open
    var product: Product
    
}

extension ScheduledProgramme: NumberIdentifiable { }

extension ScheduledProgramme: Fetchable {
    
    public typealias FetchableType = ScheduledProgramme
    
    public static var entityName: String {
        return "ScheduledProgramme"
    }
    
}
