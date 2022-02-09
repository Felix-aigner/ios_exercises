

import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var urlSessionHandler = Networking()
    
    var keyboardAdjustment: KeyboardAdjustment!
    
    // alert and succes window for after the login attempt (title with either action), containing a default message which will be modified according to the actual error.
    let alertFailure = UIAlertController(title: "Failure", message: "Username or Password incorrect", preferredStyle: .alert)
    let alertSuccess = UIAlertController(title: "Success", message: "You are logged in", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardAdjustment = KeyboardAdjustment(scrollView: scrollView)
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        
        // adding an action to close the alert windows when they appear, either a "nice" for success or a "close" for any error
        alertFailure.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"LoginFailure\" alert occured.")
        }))
        alertSuccess.addAction(UIAlertAction(title: NSLocalizedString("Nice!", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"LoginSuccess\" alert occured.")
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSuccessSegue" {
            guard let countryViewController = segue.destination as? CountryViewController
                else {
                return
            }
            countryViewController.urlSessionHandler = self.urlSessionHandler
        }
    }
    
    // function to implement keystroke functionality in the login form
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
    
    // function to be called when the form is submitted
    @IBAction func loginButtonPressed() {
        
        // appears several times to disable/enable input fields and the submit button, as well as start/stop a loadingSpinner to indicate a process to the user
        switchEnabling(state: false)
        loadingSpinner.startAnimating()

        // before any request is submitted, the password and email field are checked for a value, so that the suer can be informed in an instant
        guard self.usernameTextfield.hasText else {
            alertFailure.message = "Username missing"
            self.present(alertFailure, animated: true, completion: nil)
            self.switchEnabling(state: true)
            self.loadingSpinner.stopAnimating()
            return
        }

        guard self.passwordTextfield.hasText else {
            alertFailure.message = "Password missing" //or Username in any other case
            self.present(alertFailure, animated: true, completion: nil)
            self.switchEnabling(state: true)
            self.loadingSpinner.stopAnimating()
            return
        }
        // get email and password from the input fields and start with the networking.login function, while defining a callback beforehand
        if let email = self.usernameTextfield.text, let password = self.passwordTextfield.text {
            let callback: (_ user: User?,_ error: NetworkingError?) -> () = {
                (user, error) in
                DispatchQueue.main.async {
                    // if we are returned a user by the completionhandler, we only have to check for the registered property being true, any other csae is an error
                    if let user = user {
                        if user.registered {
                            //self.alertSuccess.message = "Login Successful"
                            //self.present(self.alertSuccess, animated: true, completion: nil)
                            print("login successful")
                            self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
                        } else {
                            self.alertFailure.message = "User not registered"
                            self.present(self.alertFailure, animated: true, completion: nil)
                        }
                        
                        self.switchEnabling(state: true)
                        self.loadingSpinner.stopAnimating()
                    }
                    if let error = error {
                        // if we get an error returned we can check for the enum we defined before, to establish a meaningful error message presented in the alert window
                        switch error {
                            case NetworkingError.invalidPassword:
                                self.alertFailure.message = "Password wrong"
                            case NetworkingError.emailNotFound:
                                self.alertFailure.message = "Email was not found"
                            case NetworkingError.userDisabled:
                                self.alertFailure.message = "User is disabled"
                            default:
                                self.alertFailure.message = "default error"
                        }
                        self.present(self.alertFailure, animated: true, completion: nil)
                        self.switchEnabling(state: true)
                        self.loadingSpinner.stopAnimating()
                    }
                }
            }
            urlSessionHandler.login(email: email, password: password, completionHandler: callback)
            
        }
    }
    // just a helper function to allow the disabling/enabling of the input fields and the submit button
    func switchEnabling(state: Bool) {
        usernameTextfield.isEnabled = state
        passwordTextfield.isEnabled = state
        loginButton.isEnabled = state
    }

}
