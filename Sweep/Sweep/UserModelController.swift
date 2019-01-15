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
    
    static var currentUser: User!
    static var residents: [User]!
    
    
    static func addUser(name: String, uid: String, email: String, password: String, isAdministrator: Bool, house: String) {
        UserModelController.currentUser = User(uid: uid, name: name, email: email, password: password, isAdministrator: isAdministrator, house: house)
        
        if let currentUser = UserModelController.currentUser {
            residents?.append(currentUser)
        }
    }
    
    static func setCurrentUser(with uid: String) {
        let matchingUser = UserModelController.residents.first{$0.uid == uid}
        UserModelController.currentUser = matchingUser
    }
    
    
}
