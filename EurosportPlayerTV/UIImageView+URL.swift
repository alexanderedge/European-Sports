//
//  UIImageView+URL.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import AlamofireImage

internal struct DarkenFilter: ImageFilter {
    
    internal var filter: Image -> Image {
        return { image in
            return UIImageEffects.imageByApplyingBlurToImage(image, withRadius: 0, tintColor: UIColor.blackColor().colorWithAlphaComponent(0.6), saturationDeltaFactor: 1, maskImage: nil)
        }
    }
}

extension UIImageView {
    
    func setImage(url: NSURL?, darken: Bool) {
        if let url = url {
            af_setImageWithURL(url, filter: darken ? DarkenFilter() : nil, imageTransition: .CrossDissolve(0.2))
        }
    }
    
}

