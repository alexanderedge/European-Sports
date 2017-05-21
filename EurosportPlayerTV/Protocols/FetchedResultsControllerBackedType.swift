//
//  FetchedResultsControllerBackedType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.

import Foundation
import CoreData

public protocol FetchedResultsControllerBackedType: class {

    associatedtype FetchedType: NSFetchRequestResult

    var fetchRequest: NSFetchRequest<FetchedType> { get }
    var fetchedResultsController: NSFetchedResultsController<FetchedType> { get }

}

extension FetchedResultsControllerBackedType {

    func objectAt(_ indexPath: IndexPath) -> FetchedType {
        return fetchedResultsController.object(at: indexPath)
    }

}
