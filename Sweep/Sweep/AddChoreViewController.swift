//
//  AddChoreViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Adds new chore to tableview. Lets users make photo
//  and title of new chore. Chores are then saven and uploaded
//

import UIKit


class AddChoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var choreImage: UIImageView! {
        didSet {
            choreImage.contentMode = .scaleAspectFill
            choreImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var choreNameTextField: UITextField!
    @IBOutlet weak var saveChoreButton: UIBarButtonItem!
    
    var imageTaken: UIImage!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make keyboard dismissable with tap
        self.hideKeyboardWithTap()
        
        // create skyBlue border arround frame
        choreImage.layer.borderWidth = 1.5
        choreImage.layer.borderColor = UIColor.white.cgColor
        
        // disable savebutton
        saveChoreButton.isEnabled = false
    }
    
    // MARK: - Textfield
    
    /// enable savebutton when textfield and image are not empty
    @IBAction func textFieldChanged(_ sender: UITextField) {
        saveChoreButton.isEnabled = (imageTaken != nil && sender.text != "") ? true : false
    }
    
    // MARK: - Image Selection
    
    /// present imagepicker when imagebutton is tapped
    @IBAction func takeImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = .rear
        
        self.present(imagePicker, animated: true)
    }
    
    /// set image after photo is taken
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTaken = image
            choreImage.image = imageTaken
            selectImageButton.setTitle(nil, for: .normal)
        }
        picker.dismiss(animated: true) {
            
            // enable savebutton if textfield is not empty
            if self.choreNameTextField.text != "" {
                self.saveChoreButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Navigation

    /// creates, saves & uploads new chore from title and image
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwindSegue" else { return }
        
        let newChore = Chore(title: choreNameTextField.text ?? "No Title", house: UserModelController.currentUser.house, image: imageTaken, lastCleaned: nil, cleaningDue: ChoreModelController.dueDate, cleaningBy: nil)
        ChoreModelController.chores.append(newChore)
        ChoreModelController.uploadChore(chore: newChore)
        ChoreModelController.saveChoresDirectory()
    }
}
