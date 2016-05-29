//
//  Channel.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(Channel)
public class Channel: NSManagedObject {
    
    @NSManaged public
    var identifier: NSNumber
    
    // MARK: - Properties
    
    @NSManaged public
    var label: String
    
    @NSManaged public
    var livelabel: String
    
    @NSManaged public
    var livesublabel: String
    
    // MARK: - Relationships
    
    @NSManaged public
    var product: Product
    
}

extension Channel: NumberIdentifiable { }

extension Channel: Fetchable {
    
    public typealias FetchableType = Channel
    
    public static func entityName() -> String {
        return "Channel"
    }
    
}
