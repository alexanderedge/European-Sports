//
//  UIViewController+Video.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import AVKit

extension UIViewController {
    internal func showVideoForURL(_ url: URL, options: [String : AnyObject]? = nil) {
        let playerController = AVPlayerViewController()
        
        let asset = AVURLAsset(url: url, options: options)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerController.player = player
        
        self.present(playerController, animated: true) {
            player.play()
        }
    }
}
