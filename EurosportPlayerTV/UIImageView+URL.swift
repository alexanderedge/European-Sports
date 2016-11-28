//
//  UIImageView+URL.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache

internal struct DarkenFilter {
    
    internal var filter: (UIImage) -> UIImage {
        return { image in
            return UIImageEffects.imageByApplyingBlur(to: image, withRadius: 0, tintColor: UIColor.black.withAlphaComponent(0.6), saturationDeltaFactor: 1, maskImage: nil)
        }
    }
}

extension UIImageView {
    
    func setImage(_ url: URL?, placeholder: UIImage? = nil, darken: Bool) {
        
        let filter = DarkenFilter()
        
        if let url = url {
            
            func completed(image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) {
                if let image = image {
                    
                    func setImageWithTransition(image: UIImage) {
                        self.alpha = 0
                        self.image = image
                        UIView.transition(with: self, duration: (cacheType == .none ? 0.2 : 0), options: .transitionCrossDissolve, animations: {
                            self.alpha = 1
                        }, completion: nil)
                    }
                    
                    if darken {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let filteredImage = filter.filter(image)
                            DispatchQueue.main.async {
                                setImageWithTransition(image: filteredImage)
                            }
                        }
                        
                    } else {
                        setImageWithTransition(image: image)
                    }
                }
            }
            
            if let placeholder = placeholder {
                sd_setImage(with: url, placeholderImage: placeholder, options: [.avoidAutoSetImage], completed: completed)
            } else {
                sd_setImage(with: url, placeholderImage: nil, options: [.avoidAutoSetImage], completed: completed)
            }

        } else {
            image = placeholder
        }
    }
    
}

