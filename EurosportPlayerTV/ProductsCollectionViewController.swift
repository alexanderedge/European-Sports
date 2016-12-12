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

class ProductsCollectionViewController: FetchedResultsCollectionViewController, FetchedResultsControllerBackedType {

    typealias FetchedType = Product
    

    var fetchRequest: NSFetchRequest<FetchedType> {
        let fetchRequest = Product.fetchRequest(nil, sortedBy: "identifier", ascending: true)
        return fetchRequest
    }
    
    var fetchedResultsController: NSFetchedResultsController<FetchedType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("unable to perform fetch: \(error)")
        }
        fetchedResultsController = frc
        
        title = NSLocalizedString("live-title", comment: "title for the products screen")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let product = objectAt(indexPath)
        
        print("selected product \(product)")
        
        guard let liveStream = product.liveStreams.firstObject as? LiveStream, let user = User.currentUser(persistentContainer.viewContext) else {
            return
        }
        
        try! liveStream.generateAuthenticatedURL(user) { result in
            switch result {
            case .success(let url):
                self.showVideoForURL(url)
                break
            case .failure(let error):
                
                self.showAlert(NSLocalizedString("catchup-failed", comment: "error starting live stream"), error: error as NSError)
                print("error generating authenticated URL: \(error)")
                break
            }
        }
    
    }
    
}


