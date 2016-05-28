//
//  CatchupParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct CatchupParser: JSONCoreDataParsingType {
    
    typealias T = Catchup
    
    enum CatchupError : ErrorType {
        case InvalidImageURL
        case InvalidTechnicalDate
        case InvalidTime
        case InvalidDate
    }
    
    static let technicalDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "y-MM-dd"
        formatter.calendar = calendar
        return formatter
    }()
    
    static let timeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.calendar = calendar
        return formatter
    }()
    
    static let calendar: NSCalendar = {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
        return calendar
    }()
    
    static func dateFromJSON(json: [String: AnyObject]) throws -> NSDate? {
        guard let startDate = technicalDateFormatter.dateFromString(try json.extract("technicaldate")) else {
            throw CatchupError.InvalidTechnicalDate
        }
        
        guard let startTime = timeFormatter.dateFromString(try json.extract("time")) else {
            throw CatchupError.InvalidTime
        }
        
        let year = calendar.component(.Year, fromDate: startDate)
        let month = calendar.component(.Month, fromDate: startDate)
        let day = calendar.component(.Day, fromDate: startDate)
        let hour = calendar.component(.Hour, fromDate: startTime)
        let minute = calendar.component(.Minute, fromDate: startTime)
        
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.dateFromComponents(dateComponents)
        
    }
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("idcatchup")
        let title: String = try json.extract("titlecatchup")
        let description: String = try json.extract("description")
        
        guard let imageURL = NSURL(string: try json.extract("pictureurl")) else {
            throw CatchupError.InvalidImageURL
        }
        
        let sportJSON: [String: AnyObject] = try json.extract("sport")
        let streamJSON: [[String: AnyObject]] = try json.extract("catchupstreams")
        
        let sportIdentifier: Int = try sportJSON.extract("id")
        let sport = try Sport.object(withIdentifier: sportIdentifier, inContext: context)
        
        let streams = StreamParser.parse(streamJSON, context: context)
        
        guard let catchup = Catchup(managedObjectContext: context) else {
            throw JSONCoreDataError.UnableToCreateInstance
        }
        
        guard let startDate = try dateFromJSON(try json.extract("startdate")) else {
            throw CatchupError.InvalidDate
        }
        catchup.startDate = startDate
        
        guard let expirationDate = try dateFromJSON(try json.extract("expirationdate")) else {
            throw CatchupError.InvalidDate
        }
        catchup.expirationDate = expirationDate
        
        catchup.streams = NSOrderedSet(array: streams)
        catchup.sport = sport
        catchup.identifier = identifier
        catchup.title = title
        catchup.catchupDescription = description
        catchup.imageURL = imageURL
        return catchup
    
    }
    
}