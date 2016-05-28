//
//  Token+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension Token {
    
    internal static func fetch(userId: String, hkey: String, completionHandler: Result<Token,NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.AuthToken.Fetch(userId: userId, hkey: hkey).request, responseSerializer: TokenResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}

extension NSURLSession {
    
    internal func authenticatedDataTaskForRequest<T>(request: NSURLRequest, user: User, responseSerializer: ResponseSerializer<T>, completionHandler: Result<T, NSError> -> Void) -> NSURLSessionDataTask {
        
        guard let token = Router.token where !token.isExpired else {
            print("no token or token has expired, fetching new token")
            
            return Token.fetch(user.identifier, hkey: user.hkey) { result in
                switch result {
                case .Success(let token):
                    Router.token = token
                    self.authenticatedDataTaskForRequest(request, user: user, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
                    break
                case.Failure(let error):
                    completionHandler(.Failure(error))
                    break
                    
                }
                
            }
            
        }
        print("using existing token")
        return dataTaskWithRequest(request, responseSerializer: responseSerializer, completionHandler: completionHandler)
        
    }
    
    internal func authenticatedDataTaskForRequest<T>(request: NSURLRequest, user: User, context: NSManagedObjectContext, responseSerializer: ManagedObjectResponseSerializer<T>, completionHandler: Result<T, NSError> -> Void) -> NSURLSessionDataTask {
        
        guard let token = Router.token where !token.isExpired else {
            print("no token or token has expired, fetching new token")
            
            return Token.fetch(user.identifier, hkey: user.hkey) { result in
                switch result {
                case .Success(let token):
                    Router.token = token
                    self.authenticatedDataTaskForRequest(request, user: user, context: context, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
                    break
                case.Failure(let error):
                    completionHandler(.Failure(error))
                    break
                    
                }
                
            }
            
        }
        print("using existing token")
        return dataTaskWithRequest(request, context: context, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
}