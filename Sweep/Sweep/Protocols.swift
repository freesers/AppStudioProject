//
//  protocols.swift
//  Sweep
//
//  Created by Sander de Vries on 26/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  File for protocols
//

import Foundation


// delegates when button/image from specific cell is tapped
protocol CellSubclassDelegate {
    func cleanedButtonPressed(cell: ChoreTableViewCell)
    func imageTapped(cell : ChoreTableViewCell)
}


// delegate to inform when to reload tableview
protocol NewChoresDelegate {
    func reloadCells()
} 
