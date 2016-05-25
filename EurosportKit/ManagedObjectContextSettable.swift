//
//  NSManagedObjectContextSettable.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 15/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedObjectContextSettable: class {
    var managedObjectContext: NSManagedObjectContext! { get set }
}