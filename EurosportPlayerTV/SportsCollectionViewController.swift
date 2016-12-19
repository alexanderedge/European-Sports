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

class SportsCollectionViewController: FetchedResultsCollectionViewController, FetchedResultsControllerBackedType, UICollectionViewDataSourcePrefetching {

    typealias FetchedType = Sport

    fileprivate var requiresLogin: Bool = false
    
    fileprivate enum SegueIdentifiers: String {
        case showCatchups = "ShowCatchups"
        case showLogin = "ShowLogin"
    }
    
    fileprivate var prefetchRequests = [IndexPath: URLSessionDataTask]()
    
    var fetchRequest: NSFetchRequest<FetchedType> {
        let predicate = NSPredicate(format: "SUBQUERY(catchups, $x, $x.expirationDate > %@).@count > 0", Date() as NSDate)
        let fetchRequest = Sport.fetchRequest(predicate, sortedBy: "name", ascending: true)
        return fetchRequest
    }
    
    var fetchedResultsController: NSFetchedResultsController<FetchedType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetch()
        
        title = NSLocalizedString("videos-title", comment: "title for the sports screen")
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: UIApplication.shared)
        
        collectionView?.remembersLastFocusedIndexPath = true
        
    }
    
    private func performFetch() {
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("unable to perform fetch: \(error)")
        }
        fetchedResultsController = frc
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.requiresLogin {
            performSegue(withIdentifier: "ShowLogin", sender: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    func applicationDidBecomeActive(_ notification: Notification) {

        performFetch()
        
        do {
            
            let passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
            
            guard let passwordItem = passwordItems.first else {
                self.requiresLogin = true
                return
            }
            
            let password = try passwordItem.readPassword()
            let email = passwordItem.account
            
            User.login(email, password: password, persistentContainer: persistentContainer) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        
                        self.fetchContent()
                        
                        break
                    case .failure:
                        
                        do {
                            try passwordItem.deleteItem()
                        } catch {
                            print("error deleting account for \(email)")
                        }
                        
                        self.requiresLogin = true
                        
                        break
                    }
                }
                
            }.resume()
            
        }
        catch {
            fatalError("Error fetching password items - \(error)")
        }
        
    }
    
    fileprivate func fetchContent() {
        
        guard let user = User.currentUser(persistentContainer.viewContext) else {
            return
        }
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            showLoadingIndicator()
        }
        
        let group = DispatchGroup()
        
        var errors = [Error]()
        
        group.enter()
        
        Catchup.fetch(user, persistentContainer: persistentContainer) { result in
            if case let .failure(error) = result {
                print("error loading catchups: \(error)")
                errors.append(error)
            } else {
                
                group.enter()
                Product.fetch(user, persistentContainer: self.persistentContainer) { result in
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
        
            self.performFetch()
            
            self.hideLoadingIndicator {
                if let error = errors.first {
                    self.showAlert(NSLocalizedString("load-failed", comment: "error loading data"), error: error as NSError)
                } else {
                    print("finished loading data");
                }
            }
            
        }
        
    }
    
    // MARK: Actions

    @IBAction func logoutButtonPressed(button: UIButton) {
        
        persistentContainer.performBackgroundTask { ctx in
            
            do {
                
                var managedObjects = [NSManagedObject]()
                
                let sports = try Sport.objectsInContext(ctx) as [NSManagedObject]
                managedObjects.append(contentsOf:sports)
                
                let products = try Product.objectsInContext(ctx) as [NSManagedObject]
                managedObjects.append(contentsOf: products)
                
                let users = try User.objectsInContext(ctx) as [NSManagedObject]
                managedObjects.append(contentsOf: users)
                
                print("deleting: \(managedObjects.count) objects")
                
                for mo in managedObjects {
                    ctx.delete(mo)
                }
                
                ctx.saveToPersistentStore()
                
                print("deleted: \(managedObjects.count) objects")
                
                // remove password
                
                let passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
                for passwordItem in passwordItems {
                    try passwordItem.deleteItem()
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifiers.showLogin.rawValue, sender: nil)
                }
                
            } catch let error as CocoaError {
                print ("unable to delete object: \(error)")
            }  catch let error as KeychainPasswordItem.KeychainError {
                print ("unable to delete keychain item: \(error)")
            } catch {
                print ("error logging out: \(error)")
            }
            
        }
        
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoubleLabelCollectionViewCell
        
        let sport = objectAt(indexPath)
        
        cell.titleLabel.text = sport.name
        cell.detailLabel.text = String.localizedStringWithFormat(sport.catchups.count > 1 ? NSLocalizedString("video-count-plural", comment: "e.g. 1 video") : NSLocalizedString("video-count-singular", comment: "e.g. 2 videos"), NumberFormatter.localizedString(from: sport.catchups.count as NSNumber, number: .none))
        cell.imageView.setImage(sport.imageURL, placeholder: UIImage(named: "catchup_placeholder"), darken: true)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! LogoutFooterCollectionReusableView
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.showCatchups.rawValue, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let sport = objectAt(indexPath)
            guard let imageURL = sport.imageURL else {
                continue
            }
            let task = URLSession.shared.dataTask(with: imageURL)
            prefetchRequests[indexPath] = task
            task.resume()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let task = prefetchRequests[indexPath] else {
                continue
            }
            task.cancel()
        }
    }
    
}

extension SportsCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier, let identifier = SegueIdentifiers(rawValue: identifierString) else {
            return
        }
        
        switch identifier {
        case .showLogin:
            
            guard let vc = segue.destination as? LoginViewController else {
                return
            }
            
            vc.persistentContainer = persistentContainer
            vc.delegate = self
            
            break
        case .showCatchups:
            
            guard let vc = segue.destination as? CatchupsCollectionViewController, let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first else {
                return
            }
            
            vc.sport = objectAt(selectedIndexPath)
            vc.persistentContainer = persistentContainer
            
            break
        }
        
        
    }
    
}

extension SportsCollectionViewController: LoginViewControllerDelegate {
    
    func loginViewController(didLogin controller: LoginViewController, user: User) {
        self.requiresLogin = false
        dismiss(animated: true) {
            self.fetchContent()
        }
    }
    
}
