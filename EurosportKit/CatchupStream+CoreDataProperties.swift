//
//  CatchupStream+CoreDataProperties.swift
//  
//
//  Created by Alexander Edge on 30/01/2017.
//
//

import Foundation
import CoreData

extension CatchupStream {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatchupStream> {
        return NSFetchRequest<CatchupStream>(entityName: "CatchupStream")
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var url: URL
    @NSManaged public var catchup: Catchup

}
