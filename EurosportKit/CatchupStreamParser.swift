//
//  StreamParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct CatchupStreamParser: JSONCoreDataParsingType {
    
    typealias T = CatchupStream
    
    enum CatchupStreamError : ErrorType {
        case InvalidURL
    }
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("id")
        
        guard let url = NSURL(string: try json.extract("url")) else {
            throw CatchupStreamError.InvalidURL
        }
        
        let stream = CatchupStream(context: context)
        stream.identifier = identifier
        stream.url = url
        return stream
        
    }
    
}