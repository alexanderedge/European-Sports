//
//  LiveStreamCollectionViewCell.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.


import UIKit

class LiveStreamCollectionViewCell: ImageCollectionViewCell {

    @IBOutlet var sportLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var logoImageView: WebImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.backgroundColor = .red
        imageView.adjustsImageWhenAncestorFocused = true

        logoImageView.adjustsImageWhenAncestorFocused = false

        sportLabel.textColor = UIColor.lightGray

        titleLabel.textColor = UIColor.white

        detailLabel.textColor = UIColor.lightGray

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.cancelCurrentImageLoad()
        logoImageView.image = nil
    }

}
