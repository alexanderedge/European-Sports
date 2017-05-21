//
//  StreamParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation
import CoreData

internal struct CatchupStreamParser: JSONCoreDataParsingType {

    typealias T = CatchupStream

    enum CatchupStreamError: Error {
        case invalidURL
    }

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int32 = try json.extract("id")

        guard let url = URL(string: try json.extract("url")) else {
            throw CatchupStreamError.invalidURL
        }

        let stream = CatchupStream(context: context)
        stream.identifier = identifier
        stream.url = url
        return stream

    }

}
