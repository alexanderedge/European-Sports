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
    
    enum ProductError : Error {
        case invalidLogoURL
    }
    
    fileprivate static let imageBaseURL = URL(string:"http://i.eurosport.fr")
    
    static func parse(_ json: [String : Any], context: NSManagedObjectContext) throws -> T {
        let identifier: Int = try json.extract("productid")
        let name: String = try json.extract("prdname")
        
        let logoJSON: [String: AnyObject] = try json.extract("logo")
        
        guard let logoURL = URL(string: try logoJSON.extract("url"), relativeTo: imageBaseURL) else {
            throw ProductError.invalidLogoURL
        }
        
        let scheduleJSON: [[String: Any]] = try json.extract("tvschedules")
        let liveStreamJSON: [[String: Any]] = try json.extract("livestreams")
        
        let product = try Product.newOrExistingObject(identifier: identifier as NSNumber, inContext: context)
        product.identifier = identifier as NSNumber
        product.name = name
        product.logoURL = logoURL
        product.scheduledProgrammes = NSOrderedSet(array: ScheduledProgrammeParser.parse(scheduleJSON, context: context))
        product.liveStreams = NSOrderedSet(array: LiveStreamParser.parse(liveStreamJSON, context: context))
        return product
        
    }
    
}
