//
//  ProductsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import CoreData
import EurosportKit

private let reuseIdentifier = "Cell"

class ProductsCollectionViewController: FetchedResultsCollectionViewController {

    typealias FetchedType = Product
    
    private var lastRefresh: NSDate?
    private let refreshInterval: NSTimeInterval = 300 // 5 minutes
    lazy private var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activity.startAnimating()
        return activity
    }()
    
    override func fetchRequest() -> NSFetchRequest {
        let fetchRequest = Product.fetchRequest(nil, sortedBy: "identifier", ascending: true)
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("live-title", comment: "title for the products screen")
        
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
                    
                    self.fetchContent(user, context: self.managedObjectContext)
                    
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

    // MARK: Actions
    
    func applicationDidBecomeActive(notification: NSNotification) {
        
        guard let user = User.currentUser(managedObjectContext) else {
            return
        }
        
        if let lastRefresh = lastRefresh where NSDate().timeIntervalSinceDate(lastRefresh) < refreshInterval {
            return
        }
        
        fetchContent(user, context: managedObjectContext)
        
    }
    
    private func fetchContent(user: User, context: NSManagedObjectContext) {
        
        // fetch both catchups and products
        
        let group = dispatch_group_create()
        
        var errors = [NSError]()
        
        dispatch_group_enter(group)
        Catchup.fetch(user, context: context) { result in
            if case let .Failure(error) = result {
                print("error loading catchups: \(error)")
                errors.append(error)
            } else {
                
                dispatch_group_enter(group)
                Product.fetch(user, context: context) { result in
                    if case let .Failure(error) = result {
                        print("error loading products: \(error)")
                        errors.append(error)
                    }
                    dispatch_group_leave(group)
                    }.resume()
                
            }
            dispatch_group_leave(group)
        }.resume()
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            
            self.hideLoadingIndicator()
            
            if let error = errors.first {
                self.showAlert(NSLocalizedString("load-failed", comment: "error loading data"), error: error)
            } else {
                print("finished loading data");
                self.lastRefresh = NSDate()
            }

        }
        
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
    }
    
    private func showLoadingIndicator() {
        
        guard loadingIndicator.superview == nil else {
            return
        }
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? LiveStreamCollectionViewCell else {
            return
        }
        
        let product = objectAt(indexPath)
        
        if let currentProgramme = product.scheduledProgrammes.firstObject as? ScheduledProgramme {
           
            cell.titleLabel.text = currentProgramme.name
            cell.sportLabel.text = currentProgramme.sport.name
            
            // instead of displaying the logo in front of the image, it would be
            // good to assemble an LSR image (front / back) so that parallax
            // can occur
            cell.imageView.setImage(currentProgramme.imageURL, darken: false)
            cell.logoImageView.setImage(product.logoURL, darken: false)
        }
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let product = objectAt(indexPath)
        
        print("selected product \(product)")
        
        guard let liveStream = product.liveStreams.firstObject as? LiveStream, user = User.currentUser(managedObjectContext) else {
            return
        }
        
        liveStream.generateAuthenticatedURL(user) { result in
            switch result {
            case .Success(let url):
                self.showVideoForURL(url)
                break
            case .Failure(let error):
                
                self.showAlert(NSLocalizedString("catchup-failed", comment: "error starting live stream"), error: error)
                print("error generating authenticated URL: \(error)")
                break
            }
        }
    
    }
    
}


