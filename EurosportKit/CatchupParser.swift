//
//  CatchupParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

internal struct CatchupParser: JSONParsingType {
    
    typealias T = Catchup
    
    enum CatchupError : ErrorType {
        case InvalidImageURL
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
        let identifier: Int = try json.extract("idcatchup")
        let sportJSON: [String: AnyObject] = try json.extract("sport")
        let sportIdentifier: Int = try sportJSON.extract("id")
        let title: String = try json.extract("titlecatchup")
        let description: String = try json.extract("description")
        let streams: [Stream] = StreamParser.parse(try json.extract("catchupstreams"))
        guard let imageURL = NSURL(string: try json.extract("pictureurl")) else {
            throw CatchupError.InvalidImageURL
        }
        return Catchup(identifier: identifier, sportIdentifier: sportIdentifier, imageURL: imageURL, title: title, description: description, streams: streams)
    }
    
}