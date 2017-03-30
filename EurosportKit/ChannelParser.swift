//
//  ChannelParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.


import Foundation
import CoreData

internal struct ChannelParser: JSONCoreDataParsingType {

    typealias T = Channel

    enum ProductError: Error {
        case invalidLogoURL
    }

    fileprivate static let imageBaseURL = URL(string:"http://i.eurosport.fr")

    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {

        print("parsing channel: \(json)")

        let identifier: Int32 = try json.extract("id")
        let title: String = try json.extract("title")
        let subtitle: String = try json.extract("subtitle")

        let logoJSON: [String: AnyObject] = try json.extract("logo")

        let logoURL = URL(string: try logoJSON.extract("url"), relativeTo: imageBaseURL)

        let scheduleJSON: [[String: Any]] = try json.extract("tvschedules")
        let liveStreamJSON: [[String: Any]] = try json.extract("streams")

        let channel = try Channel.newOrExistingObject(identifier, inContext: context)
        channel.identifier = identifier
        channel.title = title
        channel.subtitle = subtitle
        channel.logoURL = logoURL
        channel.scheduledProgrammes = NSOrderedSet(array: ScheduledProgrammeParser.parse(scheduleJSON, context: context))
        channel.liveStreams = NSOrderedSet(array: LiveStreamParser.parse(liveStreamJSON, context: context))
        return channel

    }

}
