//
//  UserModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Class used to create upload and load users
//


import Foundation


class UserModelController {
    
    // MARK: - Variables
    static var currentUser: User!
    static var residents = [User]()
    
    
    // MARK: - Creating users
    
    /// adds new user locally and on server
    static func addUser(name: String, uid: String, email: String, isAdministrator: Bool, house: String) {
        UserModelController.currentUser = User(id: 0, uid: uid, name: name, email: email,
                                               isAdministrator: String(isAdministrator), house: house)
        
        // apends user to residents and uploads to server
        guard let currentUser = UserModelController.currentUser else { return }
        UserModelController.residents.append(currentUser)
        UserModelController.uploadUser()
    }
    
    // MARK: - Network code
    
    /// uploads user to server, using currentUser description
    static func uploadUser() {
        guard let newUser = UserModelController.currentUser else {
            print("No current user set")
            return
        }
        
        // custum server URL
        let userUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/users")!
        
        // setup request
        var request = URLRequest(url: userUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = newUser.description
        request.httpBody = postString.data(using: .utf8)
        
        // create task
        let task = URLSession.shared.uploadTask(withStreamedRequest: request)
        task.resume()
    }
    
    /// loads and decodes user from server, then gives user in completion handler
    static func loadUser(with uid: String, completion: @escaping (User) -> Void) {
        
        // setup request
        let userUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/users?uid=\(uid)")!
        let request = URLRequest(url: userUrl)
        
        // create task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let user = try? JSONDecoder().decode([User].self, from: data)
                if let user = user {
                    completion(user[0])
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
