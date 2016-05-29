//
//  Product+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension Product {
    
    public static func fetch(user: User, context: NSManagedObjectContext, completionHandler: Result<([Product]),NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().authenticatedDataTaskForRequest(Router.Product.Fetch.request, user: user, context: context, responseSerializer: ProductResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}