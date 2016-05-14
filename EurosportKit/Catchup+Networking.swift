//
//  Catchup+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

extension Catchup {
    
    public static func fetch(completionHandler: Result<([Catchup],[Sport]),NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.Catchup.Fetch.request, responseSerializer: CatchupResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}