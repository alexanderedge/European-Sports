//
//  User+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    public static func login(email: String, password: String, context: NSManagedObjectContext, completionHandler: Result<User,NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.User.Login(email: email, password: password).request, context: context, responseSerializer: UserResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}