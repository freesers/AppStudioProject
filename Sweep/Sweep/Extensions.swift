//
//  Extensions.swift
//  Sweep
//
//  Created by Sander de Vries on 18/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

// tap recogniser every viewcontroller can use
extension UIViewController {
    
    func hideKeyboardWithTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    
    static let skyBlue = UIColor(red: 106.0/255.0, green: 207.0/255.0, blue: 255.0/255.0, alpha: 1)
}
