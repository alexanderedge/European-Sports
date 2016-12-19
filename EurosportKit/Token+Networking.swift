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
    
    internal static func fetch(_ userId: String, hkey: String, completionHandler: @escaping (Result<Token,Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTaskWithRequest(Router.AuthToken.fetch(userId: userId, hkey: hkey).request, responseSerializer: TokenResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}

extension URLSession {
    
    internal func refreshTokenTask<T>(_ user: User, failure: @escaping (Result<T, Error>) -> Void, success: @escaping (Void) -> Void) -> URLSessionDataTask {
        return Token.fetch(user.identifier, hkey: user.hkey) { result in
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
    
    internal func authenticatedDataTaskForRequest<T>(_ request: URLRequest, user: User, responseSerializer: ResponseSerializer<T>, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        guard let token = Router.token, token.isExpired == false else {
            return refreshTokenTask(user, failure: completionHandler) {
                self.authenticatedDataTaskForRequest(request, user: user, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
            }
        }
        return dataTaskWithRequest(request, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    internal func authenticatedDataTaskForRequest<T>(_ request: URLRequest, user: User, persistentContainer: NSPersistentContainer, responseSerializer: ManagedObjectResponseSerializer<T>, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        guard let token = Router.token, token.isExpired == false  else {
            return refreshTokenTask(user, failure: completionHandler) {
                self.authenticatedDataTaskForRequest(request, user: user, persistentContainer: persistentContainer, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
            }
        }
        return dataTaskWithRequest(request, persistentContainer: persistentContainer, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
}
