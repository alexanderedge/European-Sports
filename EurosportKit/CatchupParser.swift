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
        
        catchup.streams = NSSet(array: streams)
        catchup.sport = sport
        catchup.identifier = identifier
        catchup.title = title
        return catchup
    
    }
    
}