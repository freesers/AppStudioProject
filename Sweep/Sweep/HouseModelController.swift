//
//  HouseModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation

class HouseModelController {
    
    static let shared = HouseModelController(house: House(name: "De Lelie", residents: ["Sander"], administrator: "Sander"))
    
    static var chores = [Chore]()

    var houses: [House]
    
    init(house: House) {
        self.houses = [house]
    }
    
    func addHouse(with name: String, residents: [String], administrator: String ) {
        houses.append(House(name: name, residents: residents, administrator: administrator))
    }
    
    func addSamplehouses() {
        self.houses.append(House(name: "House1", residents: ["Sander"], administrator: "Sander"))
        self.houses.append(House(name: "House2", residents: ["Sander"], administrator: "Sander"))
        self.houses.append(House(name: "House3", residents: ["Sander"], administrator: "Sander"))
        self.houses.append(House(name: "House4", residents: ["Sander"], administrator: "Sander"))
        self.houses.append(House(name: "House5", residents: ["Sander"], administrator: "Sander"))
        self.houses.append(House(name: "House6", residents: ["Sander"], administrator: "Sander"))
    }
}


