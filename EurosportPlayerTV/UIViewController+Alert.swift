//
//  UIViewController+Alert.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit.UIAlertController

extension UIAlertController {
    
    public func addDefaultButton(title : String = NSLocalizedString("alert-ok", comment: "okay button for alert"), handler: ((UIAlertAction!) -> Void)?) {
        self.addAction(UIAlertAction(title: title, style: .Default, handler: handler))
    }
    
    public func addCancelButton(title : String = NSLocalizedString("alert-cancel", comment: "cancel button for alert"), handler: ((UIAlertAction!) -> Void)?) {
        self.addAction(UIAlertAction(title: title, style: .Cancel, handler: handler))
    }
    
    public func addDefaultButton(title : String) {
        self.addDefaultButton(title, handler: nil)
    }
    
    public func addCancelButton(title : String) {
        self.addCancelButton(title, handler: nil)
    }
    
    public convenience init(title : String = NSLocalizedString("error", comment: "an error has occurred"), error : NSError) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: .Alert)
    }
    
    public convenience init(title : String, message : String) {
        self.init(title: title, message: message, preferredStyle: .Alert)
    }
    
}

extension UIViewController {
    
    public func showAlert(title : String, message : String) {
        let vc = UIAlertController(title: title, message: message)
        vc.addDefaultButton(handler: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    public func showAlert(title : String, error : NSError) {
        let vc = UIAlertController(title: title, error: error)
        vc.addDefaultButton(handler: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}