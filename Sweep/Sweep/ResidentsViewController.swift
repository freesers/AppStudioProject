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
    @IBOutlet weak var houseNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hi, \(UserModelController.currentUser.name)"
        houseNameLabel.text = "Residents of: \(UserModelController.currentUser.house)"
        self.addResidentsToStackView()
            
            
        
    }
    
    func addResidentsToStackView() {
        for resident in HouseModelController.residents {
            let newLabel = UILabel()
            newLabel.text = resident
            newLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            residentsStackView.addArrangedSubview(newLabel)
        }
    }
    
    
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
