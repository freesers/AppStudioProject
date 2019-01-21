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
    @IBOutlet weak var disabledPickerViewLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var pickerData = [House]()
    var newUser: User? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure register button
        registerButton.layer.cornerRadius = 12
        
        // load sample houses
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
        
        self.hideKeyboardWithTap()
 
    }
    
    func formattedHouseNames() {
        
        for (i, house) in HouseModelController.houses.enumerated() {
            let houseName = house.name.replacingOccurrences(of: "*", with: " ")
            HouseModelController.houses[i].name = houseName
        }
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
    //MARK: Registration code
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard checkFields() && checkPassword() else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var uid = ""
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (AuthDataResult, Error) in
            if let user = AuthDataResult?.user {
                uid = user.uid
                self.setCurrentUser(with: uid) {
                    if self.newHouseTextfield.text! != "" {
                        self.registerNewHouse(name: self.newHouseTextfield.text!, resident: self.nameTextField.text!, administrator: self.nameTextField.text!, completion: {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "registrationSucces", sender: nil)
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                        })
                    } else {
                        self.registerExistingHouse {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "registrationSucces", sender: nil)
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                        }
                    }
                }
            }
            if let error = Error {
                print("AutError: \(error.localizedDescription)")
            }
        }
    }
    
    func setCurrentUser(with uid: String, completion: @escaping () -> Void) {
        UserModelController.currentUser = self.createUser(with: uid)
        completion()
    }
    
    func registerNewHouse(name: String, resident: String, administrator: String, completion: @escaping () -> Void) {
        HouseModelController.uploadNewHouse(with: name, residents: [resident], administrator: administrator)
        completion()
    }
    
    func registerExistingHouse(completion: @escaping () -> Void) {
        let selectedHouseRow = housePickerView.selectedRow(inComponent: 0)
        let selectedHouse = pickerData[selectedHouseRow].name
        
        HouseModelController.joinHouse(houseName: selectedHouse, residentName: nameTextField.text!)
        completion()
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
            
            let alert = UIAlertController(title: "Error", message: "Your passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
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
    

    /// creates user, either administrator or just member
    func createUser(with uid: String) -> User {
        
        // textfield is filled in
        if newHouseTextfield.text! != "" {
            
            UserModelController.addUser(name: self.nameTextField.text!, uid: uid, email: self.emailTextField.text!, password: self.passwordTextField.text!, isAdministrator: true, house: self.newHouseTextfield.text!)
            return UserModelController.currentUser!
        } else {
           
            let housePickedRow = housePickerView.selectedRow(inComponent: 0)
            let housePicked = pickerData[housePickedRow]
            UserModelController.addUser(name: self.nameTextField.text!, uid: uid, email: self.emailTextField.text!, password: self.passwordTextField.text!, isAdministrator: true, house: housePicked.name)
            return UserModelController.currentUser!
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

