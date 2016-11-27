//
//  UIViewController+Loading.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoadingIndicator() {
        
        guard self.presentedViewController == nil else {
            return
        }
        
        let vc = LoadingViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    func hideLoadingIndicator(completion: (() -> Void)? = nil) {
        
        guard (self.presentedViewController as? LoadingViewController) != nil else {
            return
        }
        
        dismiss(animated: true, completion: completion)
    }
    
}
