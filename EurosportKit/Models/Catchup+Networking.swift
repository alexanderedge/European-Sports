//
//  Catchup+Networking.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation
import CoreData

extension Catchup {

    public static func fetch(persistentContainer: NSPersistentContainer,
                             completionHandler: @escaping (Result<([Catchup])>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTaskWithRequest(Router.Catchup.fetch.request,
                                                     persistentContainer: persistentContainer,
                                                     responseSerializer: CatchupResponseSerializer.serializer(),
                                                     completionHandler: completionHandler)
    }

}
