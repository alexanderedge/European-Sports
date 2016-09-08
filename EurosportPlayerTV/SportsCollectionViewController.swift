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

class SportsCollectionViewController: FetchedResultsCollectionViewController, FetchedResultsControllerBackedType {

    typealias FetchedType = Sport
    
    fileprivate var lastRefresh: Date?
    fileprivate let refreshInterval: TimeInterval = 300 // 5 minutes
    lazy fileprivate var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.startAnimating()
        return activity
    }()
    
    
    fileprivate enum SegueIdentifiers: String {
        case ShowCatchups
    }
    
    fileprivate var selectedSport: Sport?
    
    var fetchRequest: NSFetchRequest<FetchedType> {
        let predicate = NSPredicate(format: "SUBQUERY(catchups, $x, $x.expirationDate > %@).@count > 0", Date() as NSDate)
        let fetchRequest = Sport.fetchRequest(predicate, sortedBy: "name", ascending: true)
        return fetchRequest
    }
    
    var fetchedResultsController: NSFetchedResultsController<FetchedType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("unable to perform fetch: \(error)")
        }
        fetchedResultsController = frc
        
        title = NSLocalizedString("videos-title", comment: "title for the sports screen")
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: UIApplication.shared)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check for a user, if not, prompt to login
        
        if User.currentUser(managedObjectContext) == nil {
            
            showLoadingIndicator()
            
            do {
                try User.login("alexander.edge@googlemail.com", password: "q6v-BXt-V57-E4r", context: managedObjectContext) { result in
                    
                    switch result {
                    case .success(let user):
                        print("user logged in: \(user)")
                        
                        self.fetchContent(user, context: self.managedObjectContext)
                        
                        break
                    case .failure(let error):
                        print("error logging in: \(error)")
                        
                        self.showAlert(NSLocalizedString("login-failed", comment: "error logging in"), error: error)
                        
                        self.hideLoadingIndicator()
                        
                        break
                    }
                    
                    }.resume()
            } catch {
                fatalError("unable to create request for user: \(error)")
            }
            
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    func applicationDidBecomeActive(_ notification: Notification) {
        
        guard let user = User.currentUser(managedObjectContext) else {
            return
        }
        
        if let lastRefresh = lastRefresh , Date().timeIntervalSince(lastRefresh) < refreshInterval {
            return
        }
        
        fetchContent(user, context: managedObjectContext)
        
    }
    
    fileprivate func fetchContent(_ user: User, context: NSManagedObjectContext) {
        
        // fetch both catchups and products
        
        let group = DispatchGroup()
        
        var errors = [NSError]()
        
        group.enter()
        
        try! Catchup.fetch(user, context: context) { result in
            if case let .failure(error) = result {
                print("error loading catchups: \(error)")
                errors.append(error)
            } else {
                
                group.enter()
                try! Product.fetch(user, context: context) { result in
                    if case let .failure(error) = result {
                        print("error loading products: \(error)")
                        errors.append(error)
                    }
                    group.leave()
                    }.resume()
                
            }
            group.leave()
            }.resume()
        
        group.notify(queue: DispatchQueue.main) {
            
            self.hideLoadingIndicator()
            
            if let error = errors.first {
                self.showAlert(NSLocalizedString("load-failed", comment: "error loading data"), error: error)
            } else {
                print("finished loading data");
                self.lastRefresh = Date()
            }
            
        }
        
    }
    
    fileprivate func hideLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
    }
    
    fileprivate func showLoadingIndicator() {
        
        guard loadingIndicator.superview == nil else {
            return
        }
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections , sections.count > section else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? DoubleLabelCollectionViewCell else {
            return
        }
        
        let sport = objectAt(indexPath)
        
        cell.titleLabel.text = sport.name
        cell.detailLabel.text = String.localizedStringWithFormat(sport.catchups.count > 1 ? NSLocalizedString("video-count-plural", comment: "e.g. 1 video") : NSLocalizedString("video-count-singular", comment: "e.g. 2 videos"), NumberFormatter.localizedString(from: sport.catchups.count as NSNumber, number: .none))
        cell.imageView.setImage(sport.imageURL, darken: true)

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sport = objectAt(indexPath)

        selectedSport = sport
        
        performSegue(withIdentifier: SegueIdentifiers.ShowCatchups.rawValue, sender: nil)
        
        print("selected sport \(sport.identifier)")
        
    }

}

extension SportsCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier, let identifier = SegueIdentifiers(rawValue: identifierString) , identifier == .ShowCatchups, let vc = segue.destination as? CatchupsCollectionViewController, let sport = selectedSport else {
            return
        }
        vc.sport = sport
        vc.managedObjectContext = managedObjectContext
    }
    
}
