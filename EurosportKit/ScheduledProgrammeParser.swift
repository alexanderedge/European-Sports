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
    
    enum ScheduledProgrammeError : Error {
        case invalidLogoURL
    }
    
    fileprivate static let imageBaseURL = URL(string:"http://i.eurosport.fr")
    
    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let name: String = try json.extract("tveventname")
        
        let pictureJSON: [String: Any] = try json.extract("picture")
        
        guard let imageURL = URL(string: try pictureJSON.extract("url"), relativeTo: imageBaseURL) else {
            throw ScheduledProgrammeError.invalidLogoURL
        }
        
        let sportJSON: [String: Any] = try json.extract("sport")
        let sportIdentifier: Int = try sportJSON.extract("id")
        
        let programme = try ScheduledProgramme.newOrExistingObject(identifier: identifier as NSNumber, inContext: context)
        programme.identifier = identifier as NSNumber
        programme.name = name
        programme.imageURL = imageURL
        programme.sport = try Sport.newOrExistingObject(identifier: sportIdentifier as NSNumber, inContext: context)
        return programme
        
    }
    
}
