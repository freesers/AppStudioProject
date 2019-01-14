//
//  UserModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation

class UserModelController {
    
    static let shared = UserModelController()
    
    var currentUser: User?
    var residents: [User]?
    
    
    func addUser(name: String, uid: String, email: String, password: String, isAdministrator: Bool, house: String) {
        currentUser = User(name: name, uid: uid, email: email, password: password, isAdministrator: isAdministrator, house: house)
        
        if let currentUser = currentUser {
            residents?.append(currentUser)
        }
    }
    
    
}
