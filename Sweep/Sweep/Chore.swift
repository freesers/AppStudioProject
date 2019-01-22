//
//  Chore.swift
//  Sweep
//
//  Created by Sander de Vries on 21/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

struct Chore {
    
    var title: String
    var house: String
    var photo: UIImage
    var lastCleaned: Date?
    var cleaningDue: Date?
    var cleaningBy: String?
}

struct ServerChore: Codable {
    
    var id: Int
    var title: String
    var house: String
    var image: String
}
