//
//  CatchupsResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

struct CatchupResponseSerializer {
    
    typealias T = ([Catchup],[Sport])
    
    enum CatchupError: ErrorType {
        case InvalidJSONStructure
    }
    
    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer{ data, response, error in
            let json = try VideoshopResponseSerializer.serializer().serializeResponse(data, response: response, error: error)
            let sports: [[String: AnyObject]] = try json.extract("sports")
            let catchups: [[String: AnyObject]] = try json.extract("catchups")
            return (CatchupParser.parse(catchups),SportParser.parse(sports))
        }
    }
    
}