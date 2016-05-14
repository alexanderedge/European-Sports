//
//  SportParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

internal struct SportParser: JSONParsingType {
    
    typealias T = Sport
    
    enum SportError : ErrorType {
        case InvalidImageURL
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
        let identifier: Int = try json.extract("id")
        let language: Int = try json.extract("lang")
        let name: String = try json.extract("name")
        guard let imageURL = NSURL(string: try json.extract("pictureurl")) else {
            throw SportError.InvalidImageURL
        }
        return Sport(identifier: identifier, lang: language, name: name, imageURL: imageURL)
    }
    
}
    