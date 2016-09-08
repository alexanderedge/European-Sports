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
    
    enum TokenError : Error {
        case invalidToken
        case invalidHdnea
        case invalidExpiryTimeInSeconds
        case invalidExpiryTimestamp
        case invalidStartTimestamp
    }
    
    static func parse(_ json: [String : Any]) throws -> T {
        let query: String = try json.extract("token")
        
        var parsedToken: String?
        var parsedHdnea: String?
        
        var urlComponents = URLComponents()
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
        
        let duration: TimeInterval = try json.extract("expiretimeinseconds")
        let expiryTimestamp: TimeInterval = try json.extract("expiretimestamp")
        let startTimestamp: TimeInterval = try json.extract("starttimestamp")
        
        guard let token = parsedToken else {
            throw TokenError.invalidToken
        }
        
        guard let hdnea = parsedHdnea else {
            throw TokenError.invalidHdnea
        }
        
        return Token(token: token, hdnea: hdnea, startDate: Date(timeIntervalSince1970: startTimestamp), expiryDate: Date(timeIntervalSince1970: expiryTimestamp), duration: duration)
    }
    
}
    
