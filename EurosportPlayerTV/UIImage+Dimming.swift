//
//  UIImage+Dimming.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 25/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    
    // apply a black layer over the image
    internal func imageWithBlackOverlay(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        self.drawAtPoint(.zero)
        UIColor.blackColor().colorWithAlphaComponent(alpha).setFill()
        UIBezierPath(rect: CGRectMake(0, 0, size.width, size.height)).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}