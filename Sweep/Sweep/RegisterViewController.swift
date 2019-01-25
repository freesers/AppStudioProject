//
//  RegisterViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Handles all interactions when new user registers
//  Creates Users, Houses and uploads them to the server
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Variables
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2Textfield: UITextField!
    
    @IBOutlet weak var housePickerView: UIPickerView!
    @IBOutlet weak var newHouseTextfield: UITextField!
    @IBOutlet weak var disabledPickerViewLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var pickerData = [House]()
    var newUser: User? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure register button
        registerButton.layer.cornerRadius = 12
        
        // load houses to display in the picker
        HouseModelController.loadHouses { (houses) in
            HouseModelController.houses = houses
            DispatchQueue.main.async {
                self.formattedHouseNames()
                self.pickerData = HouseModelController.houses
                self.housePickerView.reloadComponent(0)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        // configure picker
        housePickerView.dataSource = self
        housePickerView.delegate = self
        
        // make keyboard dismissable with tap
        self.hideKeyboardWithTap()
    }
    
    
    // MARK: Housepicker
    
    /// renames to correct housenames (spaces don't work in request)
    func formattedHouseNames() {
        for (i, house) in HouseModelController.houses.enumerated() {
            let houseName = house.name.replacingOccurrences(of: "*", with: " ")
            HouseModelController.houses[i].name = houseName
        }
    }
    
    /// returns component in pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// returns number of rows in pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    /// sets row titles pickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].name
    }
    
    
    // MARK: Controlling the Keyboard
    
    /// pressing return shows next textfield
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
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
    
    /// only show housepicker if no new house is filled in
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if newHouseTextfield.text != "" {
            housePickerView.isHidden = true
            disabledPickerViewLabel.isHidden = false
        } else {
            housePickerView.isHidden = false
            disabledPickerViewLabel.isHidden = true
        }
        return true
    }
    
    
    // MARK: Registration code
    
    /// creates user account at FireBase and new or existing house
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        // check whether fields and passwords are correct
        guard checkFields() && checkPassword() else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var uid = ""
        
        // create firebase account
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (AuthDataResult, Error) in
            guard let user = AuthDataResult?.user  else { return }
            uid = user.uid
            self.setCurrentUser(with: uid) {
                if self.newHouseTextfield.text! != "" {
                    self.newHouse()
                } else {
                    self.existingHouse()
                }
            }
            if let error = Error {
                print("AutError: \(error.localizedDescription)")
            }
        }
    }
    
    /// checks if textfield are filled in
    func checkFields() -> Bool {
        if nameTextField.text?.isEmpty ?? true {
            createAlert(with: "Name field is empty")
            return false
        } else if emailTextField.text?.isEmpty ?? true {
            createAlert(with: "Email field is empty")
            return false
        } else if passwordTextField.text?.isEmpty ?? true || password2Textfield.text?.isEmpty ?? true {
            createAlert(with: "Password field is empty")
            return false
        } else {
            return true
        }
    }
    
    /// checks if passwords match, shows alert and resets otherwise
    func checkPassword() -> Bool {
        if passwordTextField.text != password2Textfield.text {
            
            // create alert
            let alert = UIAlertController(title: "Error", message: "Your passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            
            // passwords match
            return true
        }
    }
    
    /// creates custom alert message
    func createAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// creates new house
    func newHouse() {
        self.registerNewHouse(name: self.newHouseTextfield.text!, resident: self.nameTextField.text!, administrator: self.nameTextField.text!, completion: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "registrationSucces", sender: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
    }
    
    /// creates existing house
    func existingHouse() {
        self.registerExistingHouse {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "registrationSucces", sender: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    /// sets current user with uid from FireBase
    func setCurrentUser(with uid: String, completion: @escaping () -> Void) {
        UserModelController.currentUser = self.createUser(with: uid)
        completion()
    }
    
    /// registers new house with new resident and uploads to server
    func registerNewHouse(name: String, resident: String, administrator: String, completion: @escaping () -> Void) {
        HouseModelController.uploadNewHouse(with: name, residents: [resident], administrator: administrator)
        completion()
    }
    
    /// residents joins existring house from picker
    func registerExistingHouse(completion: @escaping () -> Void) {
        let selectedHouseRow = housePickerView.selectedRow(inComponent: 0)
        let selectedHouse = pickerData[selectedHouseRow].name
        
        HouseModelController.joinHouse(houseName: selectedHouse, residentName: nameTextField.text!)
        completion()
    }

    /// creates user, either administrator or just member and uploads to server
    func createUser(with uid: String) -> User {
        
        // create user with new house
        if newHouseTextfield.text! != "" {
            
            UserModelController.addUser(name: self.nameTextField.text!, uid: uid, email: self.emailTextField.text!,
                                        isAdministrator: true, house: self.newHouseTextfield.text!)
            return UserModelController.currentUser!
            
        // create user with existing house
        } else {
            let housePickedRow = housePickerView.selectedRow(inComponent: 0)
            let housePicked = pickerData[housePickedRow]
            UserModelController.addUser(name: self.nameTextField.text!, uid: uid, email: self.emailTextField.text!,
                                        isAdministrator: false, house: housePicked.name)
            return UserModelController.currentUser!
        }
    }
}

