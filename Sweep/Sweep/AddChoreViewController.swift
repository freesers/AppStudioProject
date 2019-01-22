//
//  AddChoreViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit

class AddChoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var choreImage: UIImageView! {
        didSet {
            choreImage.contentMode = .scaleAspectFill
            choreImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var choreNameTextField: UITextField!
    
    var imageTaken: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWithTap()
        
        choreImage.layer.borderWidth = 1.5
        choreImage.layer.borderColor = UIColor.skyBlue.cgColor
        
        ChoreModelController.setupDates()
        
    }
    
    @IBAction func takeImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = .rear
        
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTaken = image
            choreImage.image = imageTaken
            selectImageButton.setTitle(nil, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwindSegue" else { return }
        
        let newChore = Chore(title: choreNameTextField.text ?? "No Title", house: UserModelController.currentUser.house, photo: imageTaken, lastCleaned: nil, cleaningDue: ChoreModelController.dueDate, cleaningBy: nil)
        ChoreModelController.chores.append(newChore)
    }
    

}
