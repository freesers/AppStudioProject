//
//  File.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//


import Foundation
import UIKit

struct House {
    
    var name: String
    var residents: [String]
    var administrator: String
    
}

struct Chore {
    
    var title: String
    var house: String
    var photo: UIImage
    var lastCleaned: Date?
    var cleaningDue: Date?
    var cleaningBy: String?
}

