//
//  ChoreTableViewCell.swift
//  Sweep
//
//  Created by Sander de Vries on 10/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit

protocol CellSubclassDelegate {
    func cleanedButtonPressed(cell: ChoreTableViewCell)
}

class ChoreTableViewCell: UITableViewCell {

    @IBOutlet weak var cleanedButton: UIButton!
    @IBOutlet weak var choreTitleLabel: UILabel!
    @IBOutlet weak var choreImageView: UIImageView!
    @IBOutlet weak var choreDueDateLabel: UILabel!
    @IBOutlet weak var chorePersonDueLabel: UILabel!
    @IBOutlet weak var choreDaysLeft: UILabel!
    
    var delegate: CellSubclassDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cleanedButton.layer.cornerRadius = 5
        cleanedButton.backgroundColor = UIColor.skyBlue
        choreImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cleanedButtonPressed(_ sender: UIButton) {
        self.delegate?.cleanedButtonPressed(cell: self)
    }
    
    

}
