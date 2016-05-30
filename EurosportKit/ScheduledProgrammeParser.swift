//
//  ScheduledProgrammeParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct ScheduledProgrammeParser: JSONCoreDataParsingType {
    
    typealias T = ScheduledProgramme
    
    enum ScheduledProgrammeError : ErrorType {
        case InvalidLogoURL
    }
    
    private static let imageBaseURL = NSURL(string:"http://i.eurosport.fr")
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let name: String = try json.extract("name")
        
        let pictureJSON: [String: AnyObject] = try json.extract("picture")
        
        guard let imageURL = NSURL(string: try pictureJSON.extract("url"), relativeToURL: imageBaseURL) else {
            throw ScheduledProgrammeError.InvalidLogoURL
        }
        
        let sportJSON: [String: AnyObject] = try json.extract("sport")
        let sportIdentifier: Int = try sportJSON.extract("id")
        
        let programme = try ScheduledProgramme.newOrExistingObject(identifier, inContext: context)
        programme.identifier = identifier
        programme.name = name
        programme.imageURL = imageURL
        programme.sport = try Sport.newOrExistingObject(sportIdentifier, inContext: context)
        return programme
        
    }
    
}