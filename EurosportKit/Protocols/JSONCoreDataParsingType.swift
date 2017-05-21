//
//  JSONCoreDataParsingType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 15/05/2016.

import Foundation
import CoreData

internal protocol JSONCoreDataParsingType {
    associatedtype T: NSManagedObject
    static func parse(_ json: JSONObject, context: NSManagedObjectContext) throws -> T
}

extension JSONCoreDataParsingType {
    static func parse(_ json: JSONArray, context: NSManagedObjectContext) -> [T] {
        return json.flatMap {
            do {
                return try parse($0, context: context)
            } catch {
                print("\(self) parse error: \(error)")
                return nil
            }
        }
    }
}
