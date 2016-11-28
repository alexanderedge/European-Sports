//
//  DoubleLabelCollectionViewCell.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 25/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache

class DoubleLabelCollectionViewCell: ImageCollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = Theme.Fonts.boldFont(ofSize: 38)
        
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = Theme.Fonts.boldFont(ofSize: 26)
        
    }
    
    
    
    /*
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        coordinator.addCoordinatedAnimations({
            
            if self.focused {
                self.titleLabel.textColor = Theme.Colours.Red
            } else {
                self.titleLabel.textColor = UIColor.whiteColor()
            }
            
            }, completion: nil)
        
    }
    */
    
}
