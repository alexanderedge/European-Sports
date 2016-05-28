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
import AVKit

private let reuseIdentifier = "Cell"

class CatchupsCollectionViewController: UICollectionViewController, ManagedObjectContextSettable {

    var managedObjectContext: NSManagedObjectContext!
    var sport: Sport!
    
    
    // TODO: remove this
    var token: Token!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let predicate = NSPredicate(format: "sport == %@ AND expirationDate > %@", self.sport, NSDate())
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

        title = sport.name
        view.backgroundColor = Theme.Colours.BackgroundColour
        
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
                
                // add a black overlay to the image so the 
                // text is more legible
                let adjustedImage = image.imageWithBlackOverlay(0.6)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    cell.imageView?.image = adjustedImage
                    
                }
                
                }.resume()
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let catchup = objectAt(indexPath)
        
        print("selected \(catchup.catchupDescription)")
        
        
        if let stream = catchup.streams.firstObject as? Stream {
            
            print("stream: \(stream)")
            
            self.showVideoForURL(stream.url.URLByAppendingQueryParameters(["token": token.token, "hdnea": token.hdnea]), options: nil)
            
        }
        
        
    }
    
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

extension CatchupsCollectionViewController {
    func showVideoForURL(url: NSURL, options: [String : AnyObject]?) {
        let playerController = AVPlayerViewController()
        
        let asset = AVURLAsset(URL: url, options: options)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerController.player = player
        
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = NSString(format: "%@=%@",
                                String(key).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                                String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            parts.append(part as String)
        }
        return parts.joinWithSeparator("&")
    }
    
}

extension NSURL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    func URLByAppendingQueryParameters(parametersDictionary: [String: String]) -> NSURL {
        guard let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems where !queryItems.isEmpty else {
            return NSURL(string:self.absoluteString.stringByAppendingFormat("?%@", parametersDictionary.queryParameters))!
        }
        guard let url = components.URL else {
            return self
        }
        return NSURL(string:url.absoluteString.stringByAppendingFormat("&%@", parametersDictionary.queryParameters))!
    }
}

