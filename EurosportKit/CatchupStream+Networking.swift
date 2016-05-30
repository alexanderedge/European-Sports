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
    
    private var authenticatedURL: NSURL {
        return Router.Catchup.authenticatedURL(url)
    }
    
    public func generateAuthenticatedURL(user: User, completionHandler: Result<NSURL,NSError> -> Void) {
        guard let token = Router.token where !token.isExpired else {
            NSURLSession.sharedSession().refreshTokenTask(user, failure: completionHandler) {
                completionHandler(.Success(self.authenticatedURL))
            }.resume()
            return
        }
        completionHandler(.Success(authenticatedURL))
    }
    
}