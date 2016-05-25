//
//  CatchupsResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

struct CatchupResponseSerializer {
    
    typealias T = [Catchup]
    
    enum CatchupError: ErrorType {
        case InvalidJSONStructure
    }
    
    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer{ context, data, response, error in
            let json = try VideoshopResponseSerializer.serializer().serializeResponse(data, response: response, error: error)
            let sports: [[String: AnyObject]] = try json.extract("sports")
            let catchups: [[String: AnyObject]] = try json.extract("catchups")
            
            // process the sports
            SportParser.parse(sports, context: context)
            
            //process the catchups
            return(CatchupParser.parse(catchups, context: context))
        }
    }
    
}