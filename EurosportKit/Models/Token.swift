//
//  Token.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation

internal struct Token {

    internal let token: String
    internal let hdnts: String
    internal let startDate: Date
    internal let expiryDate: Date
    internal let duration: TimeInterval

    internal var isExpired: Bool {
        return expiryDate.timeIntervalSinceNow < 0
    }

}
