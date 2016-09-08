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
    
    enum CatchupError : Error {
        case invalidImageURL
        case invalidTechnicalDate
        case invalidTime
        case invalidDate
    }
    
    static let technicalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        formatter.calendar = calendar
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.calendar = calendar
        return formatter
    }()
    
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }()
    
    static func dateFromJSON(_ json: [String: Any]) throws -> Date? {
        guard let startDate = technicalDateFormatter.date(from: try json.extract("technicaldate")) else {
            throw CatchupError.invalidTechnicalDate
        }
        
        guard let startTime = timeFormatter.date(from: try json.extract("time")) else {
            throw CatchupError.invalidTime
        }
        
        let year = calendar.component(.year, from: startDate)
        let month = calendar.component(.month, from: startDate)
        let day = calendar.component(.day, from: startDate)
        let hour = calendar.component(.hour, from: startTime)
        let minute = calendar.component(.minute, from: startTime)
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents)
        
    }
    
    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("idcatchup")
        let title: String = try json.extract("titlecatchup")
        let description: String = try json.extract("description")
        
        guard let imageURL = URL(string: try json.extract("pictureurl")) else {
            throw CatchupError.invalidImageURL
        }
        
        let sportJSON: [String: Any] = try json.extract("sport")
        let streamJSON: [[String: Any]] = try json.extract("catchupstreams")
        
        let sportIdentifier: Int = try sportJSON.extract("id")
        let sport = try Sport.newOrExistingObject(identifier: sportIdentifier as NSNumber, inContext: context)
        
        guard let startDate = try dateFromJSON(try json.extract("startdate")) else {
            throw CatchupError.invalidDate
        }
        
        guard let expirationDate = try dateFromJSON(try json.extract("expirationdate")) else {
            throw CatchupError.invalidDate
        }
        
        let catchup = try Catchup.newOrExistingObject(identifier: identifier as NSNumber, inContext: context)
        catchup.startDate = startDate
        catchup.expirationDate = expirationDate
        catchup.streams = NSOrderedSet(array: CatchupStreamParser.parse(streamJSON, context: context))
        catchup.sport = sport
        catchup.identifier = identifier as NSNumber
        catchup.title = title
        catchup.catchupDescription = description
        catchup.imageURL = imageURL
        return catchup
    
    }
    
}
