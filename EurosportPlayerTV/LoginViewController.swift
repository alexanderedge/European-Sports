//
//  LoginViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import EurosportKit
import CoreData
import Locksmith

protocol LoginViewControllerDelegate {
    
    func loginViewController(didLogin controller: LoginViewController, user: User)
    
}

class LoginViewController: UIViewController, UITextFieldDelegate, ManagedObjectContextSettable {

    internal var delegate: LoginViewControllerDelegate?
    var managedObjectContext: NSManagedObjectContext!
        
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder =  NSAttributedString(string: NSLocalizedString("login-email", comment: ""), attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)])
        passwordTextField.attributedPlaceholder =  NSAttributedString(string: NSLocalizedString("login-password", comment: ""), attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)])
        signInButton.backgroundColor = Theme.Colours.Red
        
        usernameTextField.text = "alexander.edge@googlemail.com"
        passwordTextField.text = "q6v-BXt-V57-E4r"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(sender: UIButton) {
        checkFieldsForSignIn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.hasText
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard reason == .committed else {
            return
        }
        
        if textField == passwordTextField {
            checkFieldsForSignIn()
        }
    }
    
    fileprivate func checkFieldsForSignIn() {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("missing username or password")
            return
        }
        
        signIn(username: username, password: password)
        
    }
    
    fileprivate func signIn(username: String, password: String) {
        
        showLoadingIndicator()
        
        User.login(username, password: password, context: managedObjectContext) { result in
            
            self.managedObjectContext.saveToPersistentStore()
            
            self.hideLoadingIndicator { _ in
                
                switch result {
                case .success(let user):
                    
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
                    
                    do {
                        try passwordItem.savePassword(password)
                    } catch {
                        print("error saving password: \(error)")
                    }
                    
                    print("user logged in: \(user)")
                    self.delegate?.loginViewController(didLogin: self, user: user)
                    break
                case .failure(let error):
                    print("error logging in: \(error)")
                    self.showAlert(NSLocalizedString("login-failed", comment: "error logging in"), error: error as NSError)
                    break
                }
                
            }
            
        }.resume()
        
    }
    
}
