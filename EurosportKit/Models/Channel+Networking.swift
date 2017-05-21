//
//  Product+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.

import Foundation
import CoreData

extension Channel {

    public static func fetch(persistentContainer: NSPersistentContainer,
                             completionHandler: @escaping (Result<([Channel])>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTaskWithRequest(Router.Channel.fetch.request,
                                                     persistentContainer: persistentContainer,
                                                     responseSerializer: ChannelResponseSerializer(),
                                                     completionHandler: completionHandler)
    }

}
