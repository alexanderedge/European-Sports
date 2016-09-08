//
//  Stream+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension CatchupStream {
    
    fileprivate var authenticatedURL: URL {
        return Router.Catchup.authenticatedURL(url)
    }
    
    public func generateAuthenticatedURL(_ user: User, completionHandler: @escaping (Result<URL,NSError>) -> Void) throws {
        guard let token = Router.token , !token.isExpired else {
            try URLSession.shared.refreshTokenTask(user, failure: completionHandler) {
                completionHandler(.success(self.authenticatedURL))
            }.resume()
            return
        }
        completionHandler(.success(authenticatedURL))
    }
    
}
