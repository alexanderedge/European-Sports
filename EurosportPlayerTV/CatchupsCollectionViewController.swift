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

class CatchupsCollectionViewController: FetchedResultsCollectionViewController, DataSourceType {

    typealias FetchedType = Catchup
    
    var sport: Sport!
        
    override func fetchRequest() -> NSFetchRequest {
        let predicate = NSPredicate(format: "sport == %@ AND expirationDate > %@", sport, NSDate())
        let fetchRequest = Catchup.fetchRequest(predicate, sortedBy: "startDate", ascending: false)
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = sport.name
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: UICollectionViewDataSource

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
        cell.imageView.setImage(catchup.imageURL as? NSURL, adjustBrightness: true)
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let catchup = objectAt(indexPath)
        
        print("selected \(catchup.catchupDescription)")
        
        
        if let stream = catchup.streams.firstObject as? Stream {
            
            print("stream: \(stream)")
            
            //TODO: check for a valid token and fetch a new one, if required
            showVideoForURL(stream.authenticatedURL, options: nil)
            
        }
        
        
    }
    
}



extension CatchupsCollectionViewController {
    private func showVideoForURL(url: NSURL, options: [String : AnyObject]?) {
        let playerController = AVPlayerViewController()
        
        let asset = AVURLAsset(URL: url, options: options)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerController.player = player
        
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
}



