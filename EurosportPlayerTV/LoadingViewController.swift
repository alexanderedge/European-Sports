//
//  LoadingViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private var menuPressRecognizer: UITapGestureRecognizer?
    
    lazy fileprivate var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.startAnimating()
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(visualEffectView)
        
        // disable menu button while loading
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(LoadingViewController.handleMenuButton(gr:)))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.menu.hashValue)]
        menuPressRecognizer.isEnabled = false
        self.view.addGestureRecognizer(menuPressRecognizer)
        self.menuPressRecognizer = menuPressRecognizer
        
        view.addSubview(loadingIndicator)
        loadingIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        view.addConstraint(NSLayoutConstraint(item: loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    func handleMenuButton(gr: UITapGestureRecognizer) {
        
    }
    
}
