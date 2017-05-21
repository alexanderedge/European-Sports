//
//  Token+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation
import CoreData

extension Token {

    internal static func fetch(_ userId: String, hkey: String, completionHandler: @escaping (Result<Token>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTaskWithRequest(Router.AuthToken.fetch(userId: userId, hkey: hkey).request, responseSerializer: TokenResponseSerializer(), completionHandler: completionHandler)
    }

}
