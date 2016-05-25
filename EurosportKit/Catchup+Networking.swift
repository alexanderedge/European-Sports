//
//  Catchup+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension Catchup {
    
    public static func fetch(context: NSManagedObjectContext, completionHandler: Result<([Catchup]),NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.Catchup.Fetch.request, context: context, responseSerializer: CatchupResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}