//
//  FetchedResultsControllerBackedType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

public protocol FetchedResultsControllerBackedType: class {
    func fetchRequest() -> NSFetchRequest
    var fetchedResultsController: NSFetchedResultsController! { get }
}