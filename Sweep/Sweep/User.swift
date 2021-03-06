//
//  User.swift
//  Sweep
//
//  Created by Sander de Vries on 10/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  User struct to keep track of users throughout app
//

import Foundation

struct User: Codable {
    
    var id: Int
    var uid: String
    var name: String
    var email: String
    var isAdministrator: String // would be Bool, is for convienence with server
    var house: String
    
    var description: String {

        // custom string to upload to server
        return "uid=\(uid)&name=\(name)&email=\(email)&isAdministrator=\(String(isAdministrator))&house=\(house)"
    }
}
