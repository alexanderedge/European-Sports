//
//  ProductParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal struct ProductParser: JSONCoreDataParsingType {
    
    typealias T = Product
    
    enum ProductError : ErrorType {
        
    }
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("productid")
        let name: String = try json.extract("prdname")
        
        
        let channelIdentifier: Int = try json.extract("channelid")
        let channelLiveLabel: String = try json.extract("channellivelabel")
        let channelLiveSubLabel: String = try json.extract("channellivesublabel")
        
        let channel = try Channel.newOrExistingObject(channelIdentifier, inContext: context)
        channel.livelabel = channelLiveLabel
        channel.livesublabel = channelLiveSubLabel
        
        let product = try Product.newOrExistingObject(identifier, inContext: context)
        product.identifier = identifier
        product.name = name
        product.channel = channel
        return product
        
    }
    
}