//
//  TokenParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation

internal struct TokenParser: JSONParsingType {

    typealias T = Token

    enum TokenError: Error {
        case invalidToken
        case invalidHdnts
        case invalidExpiryTimeInSeconds
        case invalidExpiryTimestamp
        case invalidStartTimestamp
    }

    static func parse(_ json: [String : Any]) throws -> T {
        let query: String = try json.extract("token")

        var parsedToken: String?
        var parsedHdnts: String?

        var urlComponents = URLComponents()
        urlComponents.query = query

        if let queryItems = urlComponents.queryItems {
            for queryItem in queryItems {
                switch queryItem.name {
                    case "token":
                        parsedToken = queryItem.value
                        break
                    case "hdnts":
                        parsedHdnts = queryItem.value?.removingPercentEncoding
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

        guard let hdnts = parsedHdnts else {
            throw TokenError.invalidHdnts
        }

        return Token(token: token, hdnts: hdnts, startDate: Date(timeIntervalSince1970: startTimestamp), expiryDate: Date(timeIntervalSince1970: expiryTimestamp), duration: duration)
    }

}
