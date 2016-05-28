//
//  FetchedResultsControllerBackedType.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol DataSourceType {
    
    associatedtype FetchedType
    
    func objectAt(indexPath: NSIndexPath) -> FetchedType
    
}

extension FetchedResultsControllerBackedType where Self: DataSourceType {
    
    func objectAt(indexPath: NSIndexPath) -> FetchedType {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! FetchedType
    }
    
}
