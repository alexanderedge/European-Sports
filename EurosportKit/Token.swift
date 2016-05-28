//
//  Token.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

public struct Token {
    
    public let token: String
    public let hdnea: String
    public let startDate: NSDate
    public let expiryDate: NSDate
    public let duration: NSTimeInterval
    
    public var isExpired: Bool {
        return expiryDate.compare(NSDate()) == .OrderedAscending
    }
    
}