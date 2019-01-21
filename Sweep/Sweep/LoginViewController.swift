//
//  ViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 07/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit
import FirebaseAuth



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginState: Bool!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWithTap()
        loginButton.layer.cornerRadius = 12
        
// Block to logout for debugging
//
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//           // performSegue(withIdentifier: "logOutSegue", sender: nil)
//            print("Logged out")
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }

        isUserLoggedIn()
    }
    
    func isUserLoggedIn() {
        DispatchQueue.main.async {
            if let user = Auth.auth().currentUser {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.emailTextField.text = user.email
                self.passwordTextField.text = "*******"
                self.loginButton.setTitle("Logging in...", for: .normal)
                let uid = user.uid
                
                UserModelController.loadUser(with: uid, completion: { (user) in
                    DispatchQueue.main.async {
                        UserModelController.currentUser = user
                        self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                })
            }
        }
    }
   
    
    //MARK: Keyboard control
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            return true
        }
        return true
    }
    
    //MARK: Login code
    @IBAction func loginButtonPressed(_ sender: Any) {
        animateButton(loginButton: loginButton)
        guard checkFields() else { return }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, authError) in
            if let result = authResult {
                print("UID: \(result.user.uid)")
                self.loginButton.setTitle("Logging in...", for: .normal)
                UserModelController.loadUser(with: result.user.uid, completion: { (user) in
                    UserModelController.currentUser = user
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                })
                
            } else {
                guard let loginError = authError else { return }
                print("Login Error: \(loginError.localizedDescription)")
            }
        }
    }
    
    func animateButton(loginButton: UIButton) {
        UIView.animate(withDuration: 0.3) {
            loginButton.transform = CGAffineTransform(scaleX: 1.5, y: 3)
            loginButton.transform = CGAffineTransform.identity
        }
    }

    
    func checkFields() -> Bool {
        if emailTextField.text! == "" {
            createAlert(with: "Missing email")
            return false
        } else if passwordTextField.text! == "" {
            createAlert(with: "Missing password")
            return false
        } else {
            return true
        }
    }
    
    /// creates custom alert message
    func createAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        emailTextField.text = ""
        passwordTextField.text = ""
        loginButton.setTitle("Login", for: .normal)
        print("worked")
    }


}

