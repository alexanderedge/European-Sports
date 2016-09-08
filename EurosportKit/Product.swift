//
//  Product.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
open class Product: NSManagedObject {
    
    @NSManaged open
    var identifier: NSNumber
    
    @NSManaged open
    var name: String
    
    @NSManaged open
    var logoURL: URL
    
    // MARK: - Relationships
    
    @NSManaged open
    var scheduledProgrammes: NSOrderedSet
    
    @NSManaged open
    var liveStreams: NSOrderedSet
    
}

extension Product: NumberIdentifiable { }

extension Product: Fetchable {
    
    public typealias FetchableType = Product
    
    public static var entityName: String {
        return "Product"
    }
    
}
