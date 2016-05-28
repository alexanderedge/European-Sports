//
//  UIImageView+URL.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(url: NSURL?, dimmed: Bool) {
        if let url = url {
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                guard let data = data, image = UIImage(data: data) else {
                    return
                }
                let finalImage = dimmed ? image.imageWithBlackOverlay(0.6) : image
                dispatch_async(dispatch_get_main_queue()) {
                    self.image = finalImage
                }
            }.resume()
        }
    }
    
}

