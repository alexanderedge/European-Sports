//
//  UIViewController+Loading.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.


import UIKit

extension UIViewController {

    func showLoadingIndicator() {

        guard presentedViewController == nil else {
            return
        }

        let vc = LoadingViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)

    }

    func hideLoadingIndicator(completion: (() -> Void)? = nil) {

        guard let _ = presentedViewController as? LoadingViewController else {
            return
        }

        dismiss(animated: true, completion: completion)
    }

}
