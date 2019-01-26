//
//  ViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 07/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Handles the login screen. If user is already logged in, the user
//  is redirected to the next screen. Loads all neccesary data from server
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginState: Bool!
    var delegate: NewChoresDelegate?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make keyboard dismissable with tap
        self.hideKeyboardWithTap()
        
        // Create correct deadlines for the chores
        ChoreModelController.setupDates()
        
        // set rounded corners to login button
        loginButton.layer.cornerRadius = 12
        
        // check if user is logged in
        isUserLoggedIn()
    }
    
    /// logs out from FireBase, use for debugging
    func logOutFB () {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Login code
    
    /// checks if user is logged in, load appropriate data
    func isUserLoggedIn() {
        DispatchQueue.main.async {
            
            // get logged in user from FireBase
            guard let user = Auth.auth().currentUser  else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
           
            // update screen with log in info
            self.emailTextField.text = user.email
            self.passwordTextField.text = "*******"
            self.loginButton.setTitle("Logging in...", for: .normal)
            let uid = user.uid
            
            // load userinfo from server
            UserModelController.loadUser(with: uid, completion: { (user) in
                
                // load residents from house
                HouseModelController.loadResidents(from: user.house) { (house) in
                    HouseModelController.residents = house.residents.turnStringInArray()
                    
                    // load chores from house
                    ChoreModelController.loadChoresDirectory {
                        self.loadChoresFromServer()
                        
                        // create up to date schedule
                        ScheduleController.rearrangePeople()
                    }
                }
                
                // segue to choresTableViewController
                DispatchQueue.main.async {
                    UserModelController.currentUser = user
                    self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
        }
    }
    
    /// logs user in from FireBase account and server information
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // animate/update button, check if fields are filled in
        animateButton(loginButton: loginButton)
        guard checkFields() else { return }
        self.loginButton.setTitle("Logging in...", for: .normal)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // sign in user from FireBase
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, authError) in
            guard let result = authResult else { return }
            let uid = result.user.uid
            // load userinfo from server
            UserModelController.loadUser(with: uid, completion: { (user) in
                UserModelController.currentUser = user
                
                // load resident from house
                HouseModelController.loadResidents(from: user.house) { (house) in
                    HouseModelController.residents = house.residents.turnStringInArray()
                    
                    // load chores from house
                    ChoreModelController.loadChoresDirectory {
                        self.loadChoresFromServer()
                        
                        // create up to date schedule
                        ScheduleController.rearrangePeople()
                    }
                }
                
                // segue to choresTableViewController
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            
            // print error if login failure
            guard let loginError = authError else { return }
            print("Login Error: \(loginError.localizedDescription)")
        }
    }
    
    /// loads chores from server and updates the array
    func loadChoresFromServer() {
        ChoreModelController.loadServerChores(from: getHouseName()) { (serverChores) in
            DispatchQueue.main.async {
                ChoreModelController.chores.removeAll()
                ChoreModelController.loadChores(chores: serverChores)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    /// gets housename, replaces spaces with asterisks
    func getHouseName() -> String {
        let house = UserModelController.currentUser.house
        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
        return formattedHouse
    }


    /// checks fields for text, show alert otherwise
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
    
    
    // MARK: - Keyboard control
    
    /// gives next field when return is pressed
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    // MARK: - Animation
    
    /// UIbutton increase/decrease animation
    func animateButton(loginButton: UIButton) {
        UIView.animate(withDuration: 0.3) {
            loginButton.transform = CGAffineTransform(scaleX: 1.5, y: 3)
            loginButton.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Navigation
    
    /// resets textfield and button when unwinded
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        emailTextField.text = ""
        passwordTextField.text = ""
        loginButton.setTitle("Login", for: .normal)
        print("worked")
    }
}

