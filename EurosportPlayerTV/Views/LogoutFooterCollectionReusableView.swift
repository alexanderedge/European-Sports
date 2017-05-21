//
//  LogoutFooterCollectionReusableView.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 27/11/2016.

import UIKit

class LogoutFooterCollectionReusableView: UICollectionReusableView {

    @IBOutlet var logoutButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override var canBecomeFocused: Bool {
        if logoutButton.isFocused {
            return false
        } else {
            return true
        }
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [logoutButton]
    }

    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }

}
