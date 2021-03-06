//
//  LoginViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.

import UIKit
import EurosportKit
import CoreData

protocol LoginViewControllerDelegate: class {

    func loginViewController(didLogin controller: LoginViewController, user: User)

}

class LoginViewController: UIViewController, UITextFieldDelegate, PersistentContainerSettable {

    internal var delegate: LoginViewControllerDelegate?
    var persistentContainer: NSPersistentContainer!

    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.attributedPlaceholder =  NSAttributedString(string: NSLocalizedString("login-email", comment: ""), attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)])
        passwordTextField.attributedPlaceholder =  NSAttributedString(string: NSLocalizedString("login-password", comment: ""), attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)])
        signInButton.backgroundColor = Theme.Colours.Yellow
        signInButton.setTitleColor(.black, for: .normal)

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

        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else {
            print("missing username or password")
            return
        }

        signIn(username: username, password: password)

    }

    fileprivate func signIn(username: String, password: String) {

        showLoadingIndicator()

        User.login(username, password: password, persistentContainer: persistentContainer) { result in

            DispatchQueue.main.async {
                self.hideLoadingIndicator { [weak self] _ in

                    guard let strongSelf = self else {
                        return
                    }

                    switch result {
                    case .success(let backingUser):

                        let user = strongSelf.persistentContainer.viewContext.object(with: backingUser.objectID) as! User

                        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)

                        do {
                            try passwordItem.savePassword(password)
                        } catch {
                            print("error saving password: \(error)")
                        }

                        print("user logged in: \(user)")
                        strongSelf.delegate?.loginViewController(didLogin: strongSelf, user: user)
                        break
                    case .failure(let error):
                        print("error logging in: \(error)")
                        strongSelf.showAlert(NSLocalizedString("login-failed", comment: "error logging in"), error: error as NSError)
                        break
                    }

                }
            }

        }.resume()

    }

}
