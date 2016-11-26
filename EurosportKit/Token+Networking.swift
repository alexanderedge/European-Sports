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
    
    internal static func fetch(_ userId: String, hkey: String, completionHandler: @escaping (Result<Token,NSError>) -> Void) throws -> URLSessionDataTask {
        return try URLSession.shared.dataTaskWithRequest(Router.AuthToken.fetch(userId: userId, hkey: hkey).request(), responseSerializer: TokenResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}

extension URLSession {
    
    internal func refreshTokenTask<T>(_ user: User, failure: @escaping (Result<T, NSError>) -> Void, success: @escaping (Void) -> Void) throws -> URLSessionDataTask {
        return try Token.fetch(user.identifier, hkey: user.hkey) { result in
            switch result {
            case .success(let token):
                Router.token = token
                success()
                break
            case.failure(let error):
                failure(.failure(error))
                break
                
            }
        }
    }
    
    internal func authenticatedDataTaskForRequest<T>(_ request: URLRequest, user: User, responseSerializer: ResponseSerializer<T>, completionHandler: @escaping (Result<T, NSError>) -> Void) throws -> URLSessionDataTask {
        guard let token = Router.token, token.isExpired == false else {
            return try refreshTokenTask(user, failure: completionHandler) {
                try! self.authenticatedDataTaskForRequest(request, user: user, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
            }
        }
        return dataTaskWithRequest(request, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    internal func authenticatedDataTaskForRequest<T>(_ request: URLRequest, user: User, context: NSManagedObjectContext, responseSerializer: ManagedObjectResponseSerializer<T>, completionHandler: @escaping (Result<T, NSError>) -> Void) throws -> URLSessionDataTask {
        guard let token = Router.token, token.isExpired == false  else {
            return try refreshTokenTask(user, failure: completionHandler) {
                try! self.authenticatedDataTaskForRequest(request, user: user, context: context, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
            }
        }
        return dataTaskWithRequest(request, context: context, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
}
