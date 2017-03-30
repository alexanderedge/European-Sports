//
//  ChannelResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.


import Foundation
import CoreData

struct ChannelResponseSerializer {

    typealias T = [Channel]

    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer { context, data, _, response, error in
            let json = try VideoshopResponseSerializer<JSONArray>.serializer().serializeResponse(data, response: response, error: error)
            var existing = Set(try Channel.objects(in: context))
            let new = ChannelParser.parse(json, context: context)

            existing.subtract(new)

            for obj in existing {
                context.delete(obj)
            }

            return new
        }
    }

}
