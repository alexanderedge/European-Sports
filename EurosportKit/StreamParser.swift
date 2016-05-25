//
//  StreamParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct StreamParser: JSONCoreDataParsingType {
    
    typealias T = Stream
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let language: Int = try json.extract("lang")
        let url: String = try json.extract("url")
        
        guard let stream = Stream(managedObjectContext: context) else {
            throw JSONCoreDataError.UnableToCreateInstance
        }
        
        stream.identifier = identifier
        stream.urlString = url
        
        return stream
        
    }
    
}