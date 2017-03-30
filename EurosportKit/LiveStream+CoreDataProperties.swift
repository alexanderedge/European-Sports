//
//  LiveStream+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension LiveStream {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiveStream> {
        return NSFetchRequest<LiveStream>(entityName: "LiveStream")
    }

    @NSManaged public var url: URL
    @NSManaged public var channel: Channel

}
