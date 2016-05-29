//
//  SportsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import CoreData
import EurosportKit

private let reuseIdentifier = "Cell"

class SportsCollectionViewController: FetchedResultsCollectionViewController {

    typealias FetchedType = Sport
    
    private enum SegueIdentifiers: String {
        case ShowCatchups
    }
    
    private var selectedSport: Sport?
    
    override func fetchRequest() -> NSFetchRequest {
        // ensure we only show sports that contain at least one video that is available to watch
        let predicate = NSPredicate(format: "SUBQUERY(catchups, $x, $x.expirationDate > %@).@count > 0", NSDate())
        let fetchRequest = Sport.fetchRequest(predicate, sortedBy: "name", ascending: true)
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("sports-title", comment: "title for the sports screen")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? DoubleLabelCollectionViewCell else {
            return
        }
        
        let sport = objectAt(indexPath)
        
        cell.titleLabel.text = sport.name
        cell.detailLabel.text = NSString.localizedStringWithFormat(sport.catchups.count > 1 ? NSLocalizedString("video-count-plural", comment: "e.g. 1 video") : NSLocalizedString("video-count-singular", comment: "e.g. 2 videos"), NSNumberFormatter.localizedStringFromNumber(sport.catchups.count, numberStyle: .NoStyle)) as String
        cell.imageView.setImage(sport.imageURL as? NSURL, adjustBrightness: true)

    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let sport = objectAt(indexPath)

        selectedSport = sport
        
        performSegueWithIdentifier(SegueIdentifiers.ShowCatchups.rawValue, sender: nil)
        
        print("selected sport \(sport.identifier)")
        
    }

}

extension SportsCollectionViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifierString = segue.identifier, identifier = SegueIdentifiers(rawValue: identifierString) where identifier == .ShowCatchups, let vc = segue.destinationViewController as? CatchupsCollectionViewController, sport = selectedSport else {
            return
        }
        vc.sport = sport
        vc.managedObjectContext = managedObjectContext
    }
    
}
