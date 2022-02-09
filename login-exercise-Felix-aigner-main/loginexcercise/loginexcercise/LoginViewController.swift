

import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextfield {
            textField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
        }
        if textField == passwordTextfield {
            loginButtonPressed()
        }
        return true
    }
    
    @IBAction func loginButtonPressed() {
        
        let alert = UIAlertController(title: "LoginAlert", message: "Username or Password incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Login", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"Login\" alert occured.")
        }))
        
        switchEnabling(state: false)
        loadingSpinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            guard self.usernameTextfield.hasText else {
                alert.message = "Username missing"
                self.present(alert, animated: true, completion: nil)
                self.switchEnabling(state: true)
                self.loadingSpinner.stopAnimating()
                return
            }
            
            guard (self.passwordTextfield.text == "pw") else {
                alert.message = "Password incorrect" //or Username in any other case
                self.present(alert, animated: true, completion: nil)
                self.switchEnabling(state: true)
                self.loadingSpinner.stopAnimating()
                return
            }
            
            alert.message = "Login successful" //or Username in any other case
            self.present(alert, animated: true, completion: nil)
            self.switchEnabling(state: true)
            self.loadingSpinner.stopAnimating()
        }
    }
    
    func switchEnabling(state: Bool) {
        usernameTextfield.isEnabled = state
        passwordTextfield.isEnabled = state
        loginButton.isEnabled = state
    }
}
