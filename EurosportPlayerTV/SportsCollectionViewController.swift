//
//  SportsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import EurosportKit

private let reuseIdentifier = "Cell"

extension UIColor {
    
    private static var randomComponent: CGFloat {
        return CGFloat(arc4random_uniform(255)) / 255
    }
    
    public static var random: UIColor {
        return UIColor(red: randomComponent, green: randomComponent, blue: randomComponent, alpha: 1.0)
    }
    
}

class SportsCollectionViewController: UICollectionViewController, ManagedObjectContextSettable {

    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = Sport.fetchRequest(nil, sortedBy: "name", ascending: true)
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

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        User.login("alexander.edge@googlemail.com", password: "q6v-BXt-V57-E4r") { result in
            
            switch result {
            case .Success(let user):
                print("user loggedn in: \(user)")
                
                Token.fetch(user.identifier, hkey: user.hkey) { result in
                    
                    switch result {
                    case .Success(let token):
                        
                        Catchup.fetch(self.managedObjectContext) { result in
                            
                            switch result {
                                
                            case .Success(let catchups):
                                
                                print("loaded \(catchups.count) catchups");
                                
                                
                                break
                            case .Failure(let error):
                                print("error: \(error)")
                                break
                                
                            }
                            
                            }.resume()
                        
                        break
                    case .Failure(let error):
                        print("error: \(error)")
                        break
                    }
                    
                    }.resume()
                
                break
            case .Failure(let error):
                print("error: \(error)")
                break
            }
            
            }.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        guard let cell = cell as? SportCollectionViewCell else {
            return
        }
        
        let sport = fetchedResultsController.objectAtIndexPath(indexPath) as! Sport
        
        cell.titleLabel.text = sport.name
        cell.detailLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%@ videos", comment: ""), NSNumberFormatter.localizedStringFromNumber(sport.catchups.count, numberStyle: .NoStyle)) as String
        
        if let url = sport.imageURL {
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let sport = fetchedResultsController.objectAtIndexPath(indexPath) as! Sport
        
        print(sport.name)
        
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

extension SportsCollectionViewController: NSFetchedResultsControllerDelegate {
    
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
