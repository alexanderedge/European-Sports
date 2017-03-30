//
//  UIViewController+Alert.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.


import UIKit.UIAlertController

extension UIAlertController {

    public func addDefaultButton(_ title: String = NSLocalizedString("alert-ok", comment: "okay button for alert"), handler: ((UIAlertAction?) -> Void)?) {
        self.addAction(UIAlertAction(title: title, style: .default, handler: handler))
    }

    public func addCancelButton(_ title: String = NSLocalizedString("alert-cancel", comment: "cancel button for alert"), handler: ((UIAlertAction?) -> Void)?) {
        self.addAction(UIAlertAction(title: title, style: .cancel, handler: handler))
    }

    public func addDefaultButton(_ title: String) {
        self.addDefaultButton(title, handler: nil)
    }

    public func addCancelButton(_ title: String) {
        self.addCancelButton(title, handler: nil)
    }

    public convenience init(title: String = NSLocalizedString("error", comment: "an error has occurred"), error: NSError) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: .alert)
    }

    public convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
    }

}

extension UIViewController {

    public func showAlert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message)
        vc.addDefaultButton(handler: nil)
        self.present(vc, animated: true, completion: nil)
    }

    public func showAlert(_ title: String, error: NSError) {
        let vc = UIAlertController(title: title, error: error)
        vc.addDefaultButton(handler: nil)
        self.present(vc, animated: true, completion: nil)
    }

}
