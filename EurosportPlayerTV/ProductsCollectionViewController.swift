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

        title = NSLocalizedString("products-title", comment: "title for the products screen")
        
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
            }
            dispatch_group_leave(group)
        }.resume()
        
        dispatch_group_enter(group)
        Product.fetch(user, context: context) { result in
            if case let .Failure(error) = result {
                print("error loading products: \(error)")
                errors.append(error)
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
        
        guard let cell = cell as? DoubleLabelCollectionViewCell else {
            return
        }
        
        let product = objectAt(indexPath)
        
        cell.titleLabel.text = product.channel.livelabel
        cell.detailLabel.text = product.channel.livesublabel
        //cell.imageView.setImage(catchup.imageURL as? NSURL, adjustBrightness: true)
        
    }
}
