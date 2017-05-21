//
//  CatchupsResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation
import CoreData

class CatchupResponseSerializer: ManagedObjectResponseSerializer<[Catchup]> {

    override func serializeResponse(_ context: NSManagedObjectContext, data: Data?, removeExisting: Bool, response: URLResponse?, error: Error?) throws -> [Catchup] {
        let json = try VideoshopResponseSerializer<JSONObject>().serializeResponse(data, response: response, error: error)
        let sports: [[String: Any]] = try json.extract("sports")
        let catchups: [[String: Any]] = try json.extract("catchups")

        _ = SportParser.parse(sports, context: context)

        var existing = Set(try Catchup.objects(in: context))
        let new = CatchupParser.parse(catchups, context: context)

        existing.subtract(new)

        for obj in existing {
            context.delete(obj)
        }

        return(new)
    }

}
