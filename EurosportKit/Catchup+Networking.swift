//
//  Catchup+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension Catchup {
    
    public static func fetch(_ user: User, persistentContainer: NSPersistentContainer, completionHandler: @escaping (Result<([Catchup]),Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.authenticatedDataTaskForRequest(Router.Catchup.fetch.request, user: user, persistentContainer: persistentContainer, responseSerializer: CatchupResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}
