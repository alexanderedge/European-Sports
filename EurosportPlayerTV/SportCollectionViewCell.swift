//
//  SportCollectionViewCell.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 25/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

class SportCollectionViewCell: ImageCollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.adjustsImageWhenAncestorFocused = true
                
    }
    
}
