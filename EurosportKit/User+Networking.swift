//
//  User+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

extension User {
    
    public static func login(email: String, password: String, completionHandler: Result<User,NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.User.Login(email: email, password: password).request, responseSerializer: UserResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}