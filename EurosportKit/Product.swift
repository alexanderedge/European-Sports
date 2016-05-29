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
public class Product: NSManagedObject {
    
    @NSManaged public
    var identifier: NSNumber
    
    @NSManaged public
    var name: String
    
    // MARK: - Relationships
    
    @NSManaged public
    var channel: Channel
    
}

extension Product: NumberIdentifiable { }

extension Product: Fetchable {
    
    public typealias FetchableType = Product
    
    public static func entityName() -> String {
        return "Product"
    }
    
}
