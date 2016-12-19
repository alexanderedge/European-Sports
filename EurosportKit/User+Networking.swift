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
    
    public static func login(_ email: String, password: String, persistentContainer: NSPersistentContainer, completionHandler: @escaping (Result<User,Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTaskWithRequest(Router.User.login(email: email, password: password).request, persistentContainer: persistentContainer, responseSerializer: LoginResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}
