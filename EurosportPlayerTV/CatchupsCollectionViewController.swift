//
//  CatchupsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 25/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import CoreData
import EurosportKit

private let reuseIdentifier = "Cell"

class CatchupsCollectionViewController: UICollectionViewController, ManagedObjectContextSettable {

    var managedObjectContext: NSManagedObjectContext!
    var sport: Sport!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let predicate = NSPredicate(format: "sport == %@", self.sport)
        let fetchRequest = Catchup.fetchRequest(predicate, sortedBy: "startDate", ascending: false)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("error fetching: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utility
    
    private func objectAt(indexPath: NSIndexPath) -> Catchup {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! Catchup
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections where sections.count > section else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? DoubleLabelCollectionViewCell else {
            return
        }
        
        let catchup = objectAt(indexPath)
        
        cell.titleLabel.text = catchup.title
        cell.detailLabel.text = catchup.catchupDescription
        
        if let url = catchup.imageURL as? NSURL {
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                
                guard let data = data, image = UIImage(data: data) else {
                    return
                }
                
                // add a black overlay
                let adjustedImage = image.imageWithBlackOverlay(0.6)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    cell.imageView?.image = adjustedImage
                    
                }
                
                }.resume()
        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}

extension CatchupsCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.collectionView?.reloadData()
    }
    
}
