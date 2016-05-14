//
//  StreamParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

internal struct StreamParser: JSONParsingType {
    
    typealias T = Stream
    
    enum StreamError : ErrorType {
        case InvalidURL
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
        let identifier: Int = try json.extract("id")
        let language: Int = try json.extract("lang")
        guard let securedURL = NSURL(string: try json.extract("securedurl")) else {
            throw StreamError.InvalidURL
        }
        guard let URL = NSURL(string: try json.extract("url")) else {
            throw StreamError.InvalidURL
        }
        return Stream(identifier: identifier, language: language, securedURL: securedURL, URL: URL)
    }
    
}