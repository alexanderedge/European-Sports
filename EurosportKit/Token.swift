//
//  Token.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

internal struct Token {
    
    internal let token: String
    internal let hdnea: String
    internal let startDate: NSDate
    internal let expiryDate: NSDate
    internal let duration: NSTimeInterval
    
    internal var isExpired: Bool {
        return expiryDate.compare(NSDate()) == .OrderedAscending
    }
    
}