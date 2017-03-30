//
//  LiveStreamParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.


import Foundation
import CoreData

internal struct LiveStreamParser: JSONCoreDataParsingType {

    typealias T = LiveStream

    enum CatchupStreamError: Error {
        case invalidURL
    }

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {

        guard let url = URL(string: try json.extract("url")) else {
            throw CatchupStreamError.invalidURL
        }

        let stream = LiveStream(context: context)
        stream.url = url
        return stream

    }

}
