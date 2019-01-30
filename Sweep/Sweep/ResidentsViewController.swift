//
//  ResidentsViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Greets user and shows residents
//  Users can log out and unwind to login screen
//

import UIKit
import FirebaseAuth


class ResidentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables
    @IBOutlet weak var leaveHouseButton: UIButton!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var ChoreScoretableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hi, \(UserModelController.currentUser.name)"
        houseNameLabel.text = "Residents: \(UserModelController.currentUser.house)"
        
        ChoreScoretableView.delegate = self
        ChoreScoretableView.dataSource = self
        ChoreScoretableView.alwaysBounceVertical = false
        
        
        // configure leaveHouseButton
        leaveHouseButton.layer.cornerRadius = 12
    }
    
    // MARK: - Tableview Datasouce
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HouseModelController.residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreScoreCell", for: indexPath)
        cell.textLabel?.text = HouseModelController.residents[indexPath.row]
        return cell
    }
  
    
    /// signs user out from FireBase and unwinds to loginscreen
    @IBAction func logOutButtonPressed() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "logOutSegue", sender: nil)
            print("Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - User Deletion
    
    /// deletes account from fireBase
    func deleteFireBase() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Account deleted from firebase")
            }
        }
    }
   
    /// creates warning alert when leave button tapped
    @IBAction func leaveHouseButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: """
                                                                       You are about to delete your account. If you continue, you will removed and deleted as a user.
                                                                       You can make a new account at the sign up screen.
                                                                       """, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete account", style: .destructive, handler: { (UIAlertAction) in
            self.deleteAccount()
            self.performSegue(withIdentifier: "deleteAccountSegue", sender: nil)
        }))
        
        present(alert, animated: true)
    }
    
    /// deletes user form all places. As resident in /houses, user in /users & user at FireBase
    func deleteAccount() {
        deleteFireBase()
        UserModelController.deleteUser(with: UserModelController.currentUser.id)
        HouseModelController.getHouseID(name: UserModelController.currentUser.house) { (id, residents) in
            HouseModelController.deleteUserFromHouse(with: id)
        }
    }
}

