//
//  JSONCoreDataParsingType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 15/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

internal protocol JSONCoreDataParsingType {
    associatedtype T: NSManagedObject
    static func parse(_ json : [String : Any], context: NSManagedObjectContext) throws -> T
    static func parse(_ json : [[String : Any]], context: NSManagedObjectContext) -> [T]
}

extension JSONCoreDataParsingType {
    static func parse(_ json : [[String : Any]], context: NSManagedObjectContext) -> [T] {
        var array : [T] = []
        for jsonDic in json {
            do {
                let obj = try self.parse(jsonDic, context: context)
                array.append(obj)
            } catch {
                print("\(self) parse error: \(error)")
            }
        }
        return array
    }
}
