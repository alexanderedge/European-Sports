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
    
    enum SportError : Error {
        case InvalidImageURL
    }
    
    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let name: String = try json.extract("name")
        
        guard let imageURL = URL(string: try json.extract("pictureurl")) else {
            throw SportError.InvalidImageURL
        }
        
        let sport = try Sport.newOrExistingObject(identifier: identifier as NSNumber, inContext: context)
        sport.name = name
        sport.imageURL = imageURL
        return sport

    }
    
}
    
