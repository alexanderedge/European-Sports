//
//  ChannelResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.

import Foundation
import CoreData

class ChannelResponseSerializer: ManagedObjectResponseSerializer<[Channel]> {

    override func serializeResponse(_ context: NSManagedObjectContext, data: Data?, removeExisting: Bool, response: URLResponse?, error: Error?) throws -> [Channel] {
        let json = try VideoshopResponseSerializer<JSONArray>().serializeResponse(data, response: response, error: error)
        var existing = Set(try Channel.objects(in: context))
        let new = ChannelParser.parse(json, context: context)

        existing.subtract(new)

        for obj in existing {
            context.delete(obj)
        }

        return new
    }

}
