//
//  UIImageView+URL.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

internal struct DarkenFilter {
    
    internal var filter: (UIImage) -> UIImage {
        return { image in
            return UIImageEffects.imageByApplyingBlur(to: image, withRadius: 0, tintColor: UIColor.black.withAlphaComponent(0.6), saturationDeltaFactor: 1, maskImage: nil)
        }
    }
}

extension UIImageView {
    
    func setImage(_ url: URL?, darken: Bool) {
        if let url = url {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let data = data {
                 
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    
                    if darken {
                        
                        let filter = DarkenFilter()
                        let darkenedImage = filter.filter(image)
                        
                        DispatchQueue.main.async {
                            self.image = darkenedImage
                        }
                        
                        
                    } else {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                    
                }
                
            }
            task.resume()
            
            //af_setImageWithURL(url, filter: darken ? DarkenFilter() : nil, imageTransition: .CrossDissolve(0.2))
        }
    }
    
}

