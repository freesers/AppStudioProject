//
//  File.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Struct to create and keep track off houses
//


import Foundation

struct House: Codable {
    
    var id: Int
    var name: String
    var residents: String // preferably [String], but the resto server gives problems
    var administrator: String
}

