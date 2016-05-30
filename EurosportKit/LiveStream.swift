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
public class LiveStream: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public
    var identifier: NSNumber
    
    @NSManaged public
    var url: NSURL
    
    // MARK: - Relationships
    
    @NSManaged public
    var programme: ScheduledProgramme
    
}

extension LiveStream: Fetchable {
    
    public typealias FetchableType = LiveStream
    
    public static func entityName() -> String {
        return "LiveStream"
    }
    
}
