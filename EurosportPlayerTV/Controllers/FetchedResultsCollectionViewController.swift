//
//  VideoCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.

import UIKit
import CoreData

class FetchedResultsCollectionViewController: UICollectionViewController, PersistentContainerSettable {

    var persistentContainer: NSPersistentContainer!

}

extension FetchedResultsCollectionViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView?.reloadData()
    }

}
