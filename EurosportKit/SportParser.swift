//
//  SportParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct SportParser: JSONCoreDataParsingType {
    
    typealias T = Sport
    
    enum SportError : ErrorType {
        case InvalidImageURL
    }
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let name: String = try json.extract("name")
        
        guard let imageURL = NSURL(string: try json.extract("pictureurl")) else {
            throw SportError.InvalidImageURL
        }
        
        guard let sport = try Sport.object(withIdentifier: identifier, inContext: context) else {
            throw JSONCoreDataError.UnableToCreateInstance
        }
        sport.name = name
        sport.imageURL = imageURL
        return sport

    }
    
}
    