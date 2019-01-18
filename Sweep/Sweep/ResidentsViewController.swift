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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hi, \(UserModelController.currentUser.name)"
       
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
