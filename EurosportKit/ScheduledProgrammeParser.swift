//
//  ScheduledProgrammeParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.


import Foundation
import CoreData

internal struct ScheduledProgrammeParser: JSONCoreDataParsingType {

    typealias T = ScheduledProgramme

    enum ScheduledProgrammeError: Error {
        case invalidLogoURL
    }

    fileprivate static let imageBaseURL = URL(string:"http://i.eurosport.fr")

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {

        print("parsing scheduled programme: \(json)")

        let identifier: Int32 = try json.extract("id")

        let pictureJSON: [String: Any] = try json.extract("picture")

        let sportJSON: [String: Any] = try json.extract("sport")
        let sportIdentifier: Int32 = try sportJSON.extract("id")

        let programme = try ScheduledProgramme.newOrExistingObject(identifier, inContext: context)
        programme.identifier = identifier
        programme.name = json.optionalExtract("name")
        programme.shortName = json.optionalExtract("shortname")
        programme.programmeDescription = json.optionalExtract("description")
        programme.competitionName = json.optionalExtract("tvcompetitionname")
        programme.imageURL = URL(string: try pictureJSON.extract("url"), relativeTo: imageBaseURL)
        programme.startDate = try DateParser.dateFromJSON(try json.extract("startdate"))
        programme.endDate = try DateParser.dateFromJSON(try json.extract("enddate"))
        programme.sport = try Sport.newOrExistingObject(sportIdentifier, inContext: context)
        return programme

    }

}
