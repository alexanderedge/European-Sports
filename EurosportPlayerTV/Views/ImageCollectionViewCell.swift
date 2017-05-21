//
//  ImageCollectionViewCell.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: WebImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.adjustsImageWhenAncestorFocused = true

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelCurrentImageLoad()
        imageView.image = nil
    }

}
