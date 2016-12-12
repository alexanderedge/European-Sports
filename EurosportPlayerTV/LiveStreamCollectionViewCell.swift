//
//  LiveStreamCollectionViewCell.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

class LiveStreamCollectionViewCell: ImageCollectionViewCell {

    @IBOutlet var sportLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var logoImageView: WebImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.adjustsImageWhenAncestorFocused = true
        
        sportLabel.textColor = UIColor.lightGray
        sportLabel.font = Theme.Fonts.boldFont(ofSize: 26)
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = Theme.Fonts.boldFont(ofSize: 38)
        
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = Theme.Fonts.boldFont(ofSize: 26)
        
    }

}
