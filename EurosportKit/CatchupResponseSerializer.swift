//
//  CatchupsResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation
import CoreData

struct CatchupResponseSerializer {

    typealias T = [Catchup]

    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer { context, data, _, response, error in

            let json = try VideoshopResponseSerializer<JSONObject>.serializer().serializeResponse(data, response: response, error: error)
            let sports: [[String: Any]] = try json.extract("sports")
            let catchups: [[String: Any]] = try json.extract("catchups")

            let _ = SportParser.parse(sports, context: context)

            var existing = Set(try Catchup.objects(in: context))
            let new = CatchupParser.parse(catchups, context: context)

            existing.subtract(new)

            for obj in existing {
                context.delete(obj)
            }

            return(new)
        }
    }

}
