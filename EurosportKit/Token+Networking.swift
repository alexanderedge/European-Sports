//
//  Token+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

extension Token {
    
    public static func fetch(userId: String, hkey: String, completionHandler: Result<Token,NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.AuthToken.Fetch(userId: userId, hkey: hkey).request, responseSerializer: TokenResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}