//
//  Product+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension Product {
    
    public static func fetch(_ user: User, persistentContainer: NSPersistentContainer, completionHandler: @escaping (Result<([Product]),Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.authenticatedDataTaskForRequest(Router.Product.fetch.request, user: user, persistentContainer: persistentContainer, responseSerializer: ProductResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}
