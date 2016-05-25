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
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let name: String = try json.extract("name")
        let imageURL: String = try json.extract("pictureurl")
        
        guard let sport = try Sport.object(withIdentifier: identifier, inContext: context) else {
            throw JSONCoreDataError.UnableToCreateInstance
        }
        sport.name = name
        sport.imageURLString = imageURL
        return sport

    }
    
}
    