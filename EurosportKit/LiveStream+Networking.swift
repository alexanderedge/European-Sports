//
//  LiveStream+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension LiveStream {
    
    fileprivate var authenticatedURL: URL {
        return Router.Catchup.authenticatedURL(url)
    }
    
    public func generateAuthenticatedURL(_ user: User, completionHandler: @escaping (Result<URL,Error>) -> Void) throws {
        guard let token = Router.token , !token.isExpired else {
            URLSession.shared.refreshTokenTask(user, failure: completionHandler) {
                completionHandler(.success(self.authenticatedURL))
                }.resume()
            return
        }
        completionHandler(.success(authenticatedURL))
    }
    
}
