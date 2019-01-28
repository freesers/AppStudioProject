//
//  ChoreTableViewCell.swift
//  Sweep
//
//  Created by Sander de Vries on 10/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Sets up the custom tableView cell with
//  the custom button, and tapable image
//

import UIKit


class ChoreTableViewCell: UITableViewCell {

    // MARK: - Variables
    @IBOutlet weak var cleanedButton: UIButton!
    @IBOutlet weak var choreTitleLabel: UILabel!
    @IBOutlet weak var choreImageView: UIImageView!
    @IBOutlet weak var choreDueDateLabel: UILabel!
    @IBOutlet weak var chorePersonDueLabel: UILabel!
    @IBOutlet weak var choreDaysLeft: UILabel!
    
    var delegate: CellSubclassDelegate?
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // make button color/cornerradius & imagebutton
        cleanedButton.layer.cornerRadius = 5
        cleanedButton.backgroundColor = UIColor.skyBlue
        cleanedButton.layer.borderWidth = 2
        cleanedButton.layer.borderColor = UIColor.skyBlue.cgColor
        
        choreImageView.layer.cornerRadius = 3
        choreImageView.layer.borderColor = UIColor.skyBlue.cgColor
        choreImageView.layer.borderWidth = 3
        addButtonOverlay(imageView: choreImageView, cell: self)
    }
    
    /// adds transparant button subview on image
    func addButtonOverlay(imageView: UIImageView, cell: ChoreTableViewCell) {
        let overlay = UIButton(frame: imageView.frame)
        imageView.isUserInteractionEnabled = true
        overlay.backgroundColor = UIColor.clear
        overlay.addTarget(cell, action: #selector(imageViewTapped), for: .touchUpInside)
        imageView.addSubview(overlay)
    }
    
    /// informs delegate image is tapped
    @objc func imageViewTapped() {
        self.delegate?.imageTapped(cell: self)
    }
    
    /// informs delegate cleaned button is tapped
    @IBAction func cleanedButtonPressed(_ sender: UIButton) {
        self.delegate?.cleanedButtonPressed(cell: self)
        animateButton(loginButton: sender)
    }
    
    // MARK: - Animation
    
    /// UIbutton increase/decrease animation
    func animateButton(loginButton: UIButton) {
        UIView.animate(withDuration: 0.3) {
            loginButton.transform = CGAffineTransform(scaleX: 1.5, y: 3)
            loginButton.transform = CGAffineTransform.identity
        }
    }
}
