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
    static var residents = [User]()
    
    
    static func addUser(name: String, uid: String, email: String, password: String, isAdministrator: Bool, house: String) {
        UserModelController.currentUser = User(id: 0, uid: uid, name: name, email: email, password: password, isAdministrator: String(isAdministrator), house: house)
        
        if let currentUser = UserModelController.currentUser {
            UserModelController.residents.append(currentUser)
            UserModelController.uploadUser()
        }
    }
    
    static func setCurrentUser(with uid: String) {
        let matchingUser = UserModelController.residents.first{$0.uid == uid}
        UserModelController.currentUser = matchingUser
    }
    
    
    ///MARK: Networking
    static func uploadUser() {
        guard let newUser = UserModelController.currentUser else {
            print("No current user set")
            return
        }
        
    
        let userUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/users")!
        var request = URLRequest(url: userUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
       // let postString = newUser.description
      //  request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.uploadTask(withStreamedRequest: request)
        task.resume()
    }
    
    static func loadUser(completion: @escaping (User) -> Void) {
        let userUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/users?uid=G6Hq5IASpZc5PRW5DuE8ALIH3bc2")!
        let request = URLRequest(url: userUrl)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let user = try? JSONDecoder().decode([User].self, from: data)
                if let user = user {
                    completion(user[0])
                }
            }
        }
        task.resume()
    
}
    

    
    
}
