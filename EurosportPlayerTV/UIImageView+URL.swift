//
//  UIImageView+URL.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import AlamofireImage

public struct DarkenFilter: ImageFilter {
    
    public var filter: Image -> Image {
        return { image in
            return UIImageEffects.imageByApplyingBlurToImage(image, withRadius: 0, tintColor: UIColor.blackColor().colorWithAlphaComponent(0.4), saturationDeltaFactor: 1, maskImage: nil)
        }
    }
}

extension UIImageView {
    
    func setImage(url: NSURL?, adjustBrightness: Bool) {
        if let url = url {
            af_setImageWithURL(url, filter: DarkenFilter(), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        }
    }
    
}

