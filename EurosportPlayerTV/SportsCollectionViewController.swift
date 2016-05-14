//
//  SportsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import EurosportKit

private let reuseIdentifier = "Cell"

extension UIColor {
    
    private static var randomComponent: CGFloat {
        return CGFloat(arc4random_uniform(255)) / 255
    }
    
    public static var random: UIColor {
        return UIColor(red: randomComponent, green: randomComponent, blue: randomComponent, alpha: 1.0)
    }
    
}

class SportsCollectionViewController: UICollectionViewController {

    var sports: [Sport] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        User.login("alexander.edge@googlemail.com", password: "q6v-BXt-V57-E4r") { result in
            
            switch result {
            case .Success(let user):
                print("user: \(user)")
                
                Token.fetch(user.identifier, hkey: user.hkey) { result in
                    
                    switch result {
                    case .Success(let token):
                        print("received token: \(token)")
                        
                        // get the listings
                        
                        Catchup.fetch { result in
                            
                            switch result {
                                
                            case .Success(let catchupTuple):
                                
                                self.sports = catchupTuple.1
                                self.collectionView?.reloadData()
                                
                                
                                break
                            case .Failure(let error):
                                print("error: \(error)")
                                break
                                
                            }
                            
                            }.resume()
                        
                        break
                    case .Failure(let error):
                        print("error: \(error)")
                        break
                    }
                    
                    }.resume()
                
                break
            case .Failure(let error):
                print("error: \(error)")
                break
            }
            
            }.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sports.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
    
        
        
        // Configure the cell
        cell.backgroundColor = UIColor.random
        
        let sport = sports[indexPath.item]
        
        //cell.imageView.image =
        
        NSURLSession.sharedSession().dataTaskWithURL(sport.imageURL) { data, response, error in
         
            guard let data = data, image = UIImage(data: data) else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                cell.imageView?.image = image
                
            }
            
        }.resume()
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let sport = sports[indexPath.item]
        
        print(sport.name)
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
