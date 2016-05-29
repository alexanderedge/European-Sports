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
    private var lastRefresh: NSDate?
    private let refreshInterval: NSTimeInterval = 300 // 5 minutes
    lazy private var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activity.startAnimating()
        return activity
    }()
    
    override func fetchRequest() -> NSFetchRequest {
        // ensure we only show sports that contain at least one video that is available to watch
        let predicate = NSPredicate(format: "SUBQUERY(catchups, $x, $x.expirationDate > %@).@count > 0", NSDate())
        let fetchRequest = Sport.fetchRequest(predicate, sortedBy: "name", ascending: true)
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("sports-title", comment: "title for the sports screen")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: UIApplication.sharedApplication())
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check for a user, if not, prompt to login
        
        if User.currentUser(managedObjectContext) == nil {
         
            showLoadingIndicator()
            
            User.login("alexander.edge@googlemail.com", password: "q6v-BXt-V57-E4r", context: managedObjectContext) { result in
                
                switch result {
                case .Success(let user):
                    print("user logged in: \(user)")
                    
                    self.fetchCatchups(user, context: self.managedObjectContext)
                    
                    break
                case .Failure(let error):
                    print("error logging in: \(error)")
                    
                    self.showAlert(NSLocalizedString("login-failed", comment: "error logging in"), error: error)
                    
                    self.hideLoadingIndicator()
                    
                    break
                }
                
            }.resume()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        
        guard let user = User.currentUser(managedObjectContext) else {
            return
        }
        
        if let lastRefresh = lastRefresh where NSDate().timeIntervalSinceDate(lastRefresh) < refreshInterval {
            return
        }
        
        fetchCatchups(user, context: managedObjectContext)
        
    }
    
    // MARK: Actions
    
    private func fetchCatchups(user: User, context: NSManagedObjectContext) {
        Catchup.fetch(user, context: context) { result in
            
            switch result {
                
            case .Success(let catchups):
                
                self.hideLoadingIndicator()
                
                print("loaded \(catchups.count) catchups");
                
                self.lastRefresh = NSDate()
                
                break
            case .Failure(let error):
                print("error loading catchups: \(error)")
                
                self.hideLoadingIndicator()
                
                self.showAlert(NSLocalizedString("catchup-load-failed", comment: "error loading catchups"), error: error)
                
                break
                
            }
            
        }.resume()
    }

    private func hideLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
    }
    
    private func showLoadingIndicator() {
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
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
        
        print("selected \(sport.name)")
        
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
