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
        case InvalidLogoURL
    }
    
    private static let imageBaseURL = NSURL(string:"http://i.eurosport.fr")
    
    static func parse(json: [String : AnyObject], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("productid")
        let name: String = try json.extract("prdname")
        
        let logoJSON: [String: AnyObject] = try json.extract("logo")
        
        guard let logoURL = NSURL(string: try logoJSON.extract("url"), relativeToURL: imageBaseURL) else {
            throw ProductError.InvalidLogoURL
        }
        
        let scheduleJSON: [[String: AnyObject]] = try json.extract("tvschedules")
        let liveStreamJSON: [[String: AnyObject]] = try json.extract("livestreams")
        
        let product = try Product.newOrExistingObject(identifier, inContext: context)
        product.identifier = identifier
        product.name = name
        product.logoURL = logoURL
        product.scheduledProgrammes = NSOrderedSet(array: ScheduledProgrammeParser.parse(scheduleJSON, context: context))
        product.liveStreams = NSOrderedSet(array: LiveStreamParser.parse(liveStreamJSON, context: context))
        return product
        
    }
    
}