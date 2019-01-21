//
//  ResidentsViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResidentsViewController: UIViewController {
    
    let currentHouse = UserModelController.currentUser.house
    var residents = [String]()
    
    @IBOutlet weak var residentsStackView: UIStackView!
    @IBOutlet weak var currentResidentLabel: UILabel!
    @IBOutlet weak var houseNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hi, \(UserModelController.currentUser.name)"
        houseNameLabel.text = "Residents of: \(UserModelController.currentUser.house)"
        
        residentsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        HouseModelController.loadResidents(from: currentHouse) { (house) in
            self.turnStringInArray(residentString: house.residents)
            
            DispatchQueue.main.async {
                self.addResidentsToStackView()
            }
            
        }
        
        
       
    }
    
    func turnStringInArray(residentString: String) {
        let data = residentString.data(using: .utf8)
        if let stringArray = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String] {
            residents = stringArray
        }
    }
    
    func addResidentsToStackView() {
        for resident in residents {
            let newLabel = UILabel()
            newLabel.text = resident
            newLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            print("Label", newLabel)
            residentsStackView.addArrangedSubview(newLabel)
        }
    }
    
    
    //let data = house[0].residents.data(using: String.Encoding.utf8, allowLossyConversion: false)
    //
    //if let stringArray = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String] {
    //    print(stringArray)
    //}
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "logOutSegue", sender: nil)
            print("Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    // MARK: - Navigation
    
    

}
