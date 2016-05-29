//
//  Stream+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

extension Stream {
    
    public var authenticatedURL: NSURL {
        return Router.Catchup.authenticatedURL(url as! NSURL)
    }
    
}