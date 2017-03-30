//
//  DoubleLabelCollectionViewCell.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 25/05/2016.


import UIKit

class DoubleLabelCollectionViewCell: ImageCollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.textColor = UIColor.white
        detailLabel.textColor = UIColor.lightGray

    }

}
