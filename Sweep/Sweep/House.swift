//
//  File.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

class House {
    
    var name: String
    var chores: [Chore]?
    var residents: [String]
    var administrator: String
    
    init(name: String, residents: [String], administrator: String) {
        self.name = name
        self.residents = residents
        self.administrator = administrator
    }
    
}


struct Chore {
    
    var title: String
    var photo: UIImage
    var checklist: [String]
    var lastCleaned: Date
    var cleaningDue: Date
    var cleaningBy: String
}

