//
//  TestHelper.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 05/04/2017.
//  Copyright © 2017 Alexander Edge. All rights reserved.
//

import Foundation
import CoreData
@testable import EurosportKit

func jsonFromBundle<T>(fileName: String) -> T {
    let fileURL = Bundle(for: EurosportKitTests.self).url(forResource: fileName, withExtension: "json")!
    let data = try! Data(contentsOf: fileURL)
    let json = try! JSONSerialization.jsonObject(with: data, options: [])
    return json as! T
}

func utcDate(year: Int, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
    return Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC")!, year: year, month: month, day: day, hour: hour, minute: minute, second: second))
}

func cetDate(year: Int, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
    return Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "CET")!, year: year, month: month, day: day, hour: hour, minute: minute, second: second))
}

var model: NSManagedObjectModel = {
    let bundle = Bundle(for: Sport.self)
    let modelURL = bundle.url(forResource: "Eurosport", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
}()

func createPersistentStoreCoordinatorWithInMemoryStore() -> NSPersistentStoreCoordinator {
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    return psc
}

