//
//  User+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation
import CoreData

extension User {

    public static func login(_ email: String, password: String, persistentContainer: NSPersistentContainer, completionHandler: @escaping (Result<User>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTaskWithRequest(Router.User.login(email: email, password: password).request, persistentContainer: persistentContainer, responseSerializer: LoginResponseSerializer(), completionHandler: completionHandler)
    }

}
