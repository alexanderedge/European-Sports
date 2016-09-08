//
//  LiveStream.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(LiveStream)
open class LiveStream: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged open
    var identifier: NSNumber
    
    @NSManaged open
    var url: URL
    
    // MARK: - Relationships
    
    @NSManaged open
    var programme: ScheduledProgramme
    
}

extension LiveStream: Fetchable {
    
    public typealias FetchableType = LiveStream
    
    public static var entityName: String {
        return "LiveStream"
    }
    
}
