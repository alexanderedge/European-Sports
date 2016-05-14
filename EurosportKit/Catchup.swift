//
//  Catchup.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

public struct Catchup {
    
    public let identifier: Int
    public let sportIdentifier: Int
    public let imageURL: NSURL
    public let title: String
    public let description: String
    public let streams: [Stream]
    
}