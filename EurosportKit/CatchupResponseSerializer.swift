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
    
    enum CatchupError: Error {
        case invalidJSONStructure
    }
    
    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer{ context, data, response, error in
            
            guard let json = try VideoshopResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [String: Any] else {
                throw CatchupError.invalidJSONStructure
            }
            
            let sports: [[String: Any]] = try json.extract("sports")
            let catchups: [[String: Any]] = try json.extract("catchups")
            
            // process the sports
            let _ = SportParser.parse(sports, context: context)
            
            //process the catchups
            return(CatchupParser.parse(catchups, context: context))
        }
    }
    
}
