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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginButton.layer.cornerRadius = 12
        
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
        guard checkFields() else { return }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, authError) in
            if let result = authResult {
                print("UID: \(result.user.uid)")
            } else {
                guard let loginError = authError else { return }
                print("Login Error: \(loginError.localizedDescription)")
            }
        }
        
        if Auth.auth().currentUser == nil {
            
            // user is signed in
            performSegue(withIdentifier: "logInSegue", sender: nil)
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
        print("worked")
    }


}

