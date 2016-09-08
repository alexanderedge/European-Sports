//
//  User+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    public static func login(_ email: String, password: String, context: NSManagedObjectContext, completionHandler: @escaping (Result<User,NSError>) -> Void) throws -> URLSessionDataTask {
        return try URLSession.shared.dataTaskWithRequest(Router.User.login(email: email, password: password).request(), context: context, responseSerializer: UserResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}
