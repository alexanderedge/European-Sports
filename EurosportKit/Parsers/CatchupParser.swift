//
//  CatchupParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation
import CoreData

internal struct CatchupParser: JSONCoreDataParsingType {

    typealias T = Catchup

    enum CatchupError: Error {
        case invalidImageURL
    }

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int32 = try json.extract("idcatchup")
        let title: String = try json.extract("titlecatchup")
        let description: String = try json.extract("description")
        let duration: Double = try json.extract("durationInSeconds")

        guard let imageURL = URL(string: try json.extract("pictureurl")) else {
            throw CatchupError.invalidImageURL
        }

        let sportJSON: [String: Any] = try json.extract("sport")
        let streamJSON: [[String: Any]] = try json.extract("catchupstreams")

        let sportIdentifier: Int32 = try sportJSON.extract("id")
        let sport = try Sport.newOrExistingObject(sportIdentifier, inContext: context)

        let startDate = try DateParser.parse(try json.extract("startdate"))
        let expirationDate = try DateParser.parse(try json.extract("expirationdate"))

        let catchup = try Catchup.newOrExistingObject(identifier, inContext: context)
        catchup.startDate = startDate
        catchup.expirationDate = expirationDate

        // delete any existing streams
        for stream in catchup.streams {
            context.delete(stream as! CatchupStream)
        }
        // assign new streams
        catchup.streams = NSOrderedSet(array: CatchupStreamParser.parse(streamJSON, context: context))
        catchup.sport = sport
        catchup.identifier = identifier
        catchup.title = title
        catchup.catchupDescription = description
        catchup.imageURL = imageURL
        catchup.duration = duration
        return catchup

    }

}
