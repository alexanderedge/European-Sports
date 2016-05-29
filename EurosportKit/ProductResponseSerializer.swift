//
//  ProductResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

struct ProductResponseSerializer {
    
    typealias T = [Product]
    
    enum ProductError: ErrorType {
        case InvalidJSONStructure
    }
    
    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer{ context, data, response, error in
            guard let json = try VideoshopResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [[String: AnyObject]] else {
                throw ProductError.InvalidJSONStructure
            }
            return ProductParser.parse(json, context: context)
        }
    }
    
}