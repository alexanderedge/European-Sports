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
    
    // TODO: remove this
    var token: Token!
    
    override func fetchRequest() -> NSFetchRequest {
        let predicate = NSPredicate(format: "sport == %@ AND expirationDate > %@", sport, NSDate())
        let fetchRequest = Catchup.fetchRequest(predicate, sortedBy: "startDate", ascending: false)
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = sport.name
        view.backgroundColor = Theme.Colours.BackgroundColour
        
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
            
            self.showVideoForURL(stream.authenticatedURL, options: nil)
            
        }
        
        
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



