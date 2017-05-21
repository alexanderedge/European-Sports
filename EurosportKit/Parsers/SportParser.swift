//
//  SportParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation
import CoreData

internal struct SportParser: JSONCoreDataParsingType {

    typealias T = Sport

    enum SportError: Error {
        case invalidImageURL
    }

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int32 = try json.extract("id")
        let name: String = try json.extract("name")

        let sport = try Sport.newOrExistingObject(identifier, inContext: context)
        sport.name = name

        do {
            sport.imageURL = URL(string: try json.extract("pictureurl"))
        } catch {

        }

        return sport

    }

}
