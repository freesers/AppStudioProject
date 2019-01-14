//
//  RegisterViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2Textfield: UITextField!
    
    @IBOutlet weak var housePickerView: UIPickerView!
    @IBOutlet weak var newHouseTextfield: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var pickerData = HouseModelController.shared.houses
    var newUser: User? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password2Textfield.textContentType = .password
    
        
        // configure register button
        registerButton.layer.cornerRadius = 12
        
        // load sample houses
        HouseModelController.shared.addSamplehouses()
        pickerData = HouseModelController.shared.houses
        
        // configure picker
        housePickerView.dataSource = self
        housePickerView.delegate = self
 
    }
    
    //MARK - Housepicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].name
    }
    
    //MARK: Controlling the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameTextField:
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            password2Textfield.becomeFirstResponder()
        case password2Textfield:
            password2Textfield.resignFirstResponder()
        case newHouseTextfield:
            newHouseTextfield.resignFirstResponder()
        default:
            return true
        }
        return true
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if createUser() {
            performSegue(withIdentifier: "registrationSucces", sender: nil)
        } else {
            print("error")
        }
    }
    

    
    func createUser() -> Bool {
        
        var registrationSucces = false
        
        
        guard checkPassword() else { return false }
        
        let tryUid = makeFIBUser()
        
        guard let uid = tryUid else { return false}
        guard nameTextField.text != nil else {return false}
        
        if let newHouse = newHouseTextfield.text {
            
            let alert = UIAlertController(title: "You will create a new house", message: "By creating a new house, you will be the administrator and add chores", preferredStyle: .alert)
            alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                UserModelController.shared.addUser(name: self.nameTextField.text!, uid: uid, email: self.emailTextField.text!, password: self.passwordTextField.text!, isAdministrator: true, house: newHouse)
                registrationSucces = true
            })))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                self.newHouseTextfield.text = nil
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        return registrationSucces
    }
   
    /// checks if passwords match, shows alert and resets otherwise
    func checkPassword() -> Bool {
        
        if passwordTextField.text != password2Textfield.text {
            
            let alert = UIAlertController(title: "Error", message: "Your passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.passwordTextField.text = ""
                self.password2Textfield.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            return false
       
        } else if passwordTextField.text == "" {
            
            let alert = UIAlertController(title: "Error", message: "No password entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.passwordTextField.text = ""
                self.password2Textfield.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /// register user at FireBase and return UID
    func makeFIBUser() -> String? {
        
        var uid: String? = nil
        guard let email = emailTextField.text, let password = passwordTextField.text else { return uid }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, Error) in
            uid = user?.user.uid
            print(Error.debugDescription)
        }
        return uid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

