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
    
    enum StreamError : ErrorType {
        case InvalidURL
    }
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        let language: Int = try json.extract("lang")
        
        guard let url = NSURL(string: try json.extract("url")) else {
            throw StreamError.InvalidURL
        }
        
        let stream = Stream(managedObjectContext: context)!
        stream.identifier = identifier
        stream.url = url
        return stream
        
    }
    
}