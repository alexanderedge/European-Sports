//
//  TokenParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

internal struct TokenParser: JSONParsingType {
    
    typealias T = Token
    
    enum TokenError : ErrorType {
        case InvalidToken
        case InvalidHdnea
        case InvalidExpiryTimeInSeconds
        case InvalidExpiryTimestamp
        case InvalidStartTimestamp
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
        let query: String = try json.extract("token")
        
        var parsedToken: String?
        var parsedHdnea: String?
        
        let urlComponents = NSURLComponents()
        urlComponents.query = query
        
        if let queryItems = urlComponents.queryItems {
            for queryItem in queryItems {
                switch queryItem.name {
                    case "token":
                        parsedToken = queryItem.value
                        break
                    case "hdnea":
                        parsedHdnea = queryItem.value
                        break
                    default:
                        break
                }
            }
        }
        
        let duration: NSTimeInterval = try json.extract("expiretimeinseconds")
        let expiryTimestamp: NSTimeInterval = try json.extract("expiretimestamp")
        let startTimestamp: NSTimeInterval = try json.extract("starttimestamp")
        
        guard let token = parsedToken else {
            throw TokenError.InvalidToken
        }
        
        guard let hdnea = parsedHdnea else {
            throw TokenError.InvalidHdnea
        }
        
        return Token(token: token, hdnea: hdnea, startDate: NSDate(timeIntervalSince1970: startTimestamp), expiryDate: NSDate(timeIntervalSince1970: expiryTimestamp), duration: duration)
    }
    
}
    