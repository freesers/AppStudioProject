//
//  Extensions.swift
//  Sweep
//
//  Created by Sander de Vries on 18/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  File to keep track of all extensions
//

import Foundation
import UIKit


extension UIViewController: UITextFieldDelegate {
    
    /// dismisses keyboard in every viewcontroller with tap
    func hideKeyboardWithTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    /// hides keyboard when return is pressed
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
        
    }
}


extension UIColor {
    
    // the blue color used troughout the app
    static let skyBlue = UIColor(red: 106.0/255.0, green: 207.0/255.0, blue: 255.0/255.0, alpha: 1)
    static let skyOrange = UIColor(red: 1, green: 153/255, blue: 106/255, alpha: 1)
    static let skyGray = UIColor(red: 98/255.0, green: 120/255.0, blue: 130/255.0, alpha: 1)
}


extension String {
    
    /// returns specific formatted string in array
    func turnStringInArray() -> [String] {
        let data = self.data(using: .utf8)
        if let stringArray = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String] {
            return stringArray
        }
        return [String]()
    }
}


extension DateComponents {
    
    // first cleaning date
    static var cleaningDayComponent = DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2019, month: 1, day: 27,
                                                     hour: 23, minute: 59, second: 59, nanosecond: nil, weekday: 1, weekdayOrdinal: nil,
                                                     quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    static var firstCleaningDate = Calendar.current.date(from: DateComponents.cleaningDayComponent)
    static var cleaningDates = [Date]()
    static var cleaningDue = Date()
   
    /// appends cleaning dates to array from first cleaning date, incrementing by week
    static func createDates() {
        for _ in 1...100 {
            let date = DateComponents.firstCleaningDate!
            DateComponents.cleaningDates.append(date)
            self.firstCleaningDate = firstCleaningDate?.addingTimeInterval(60 * 60 * 24 * 7)
        }
    }
    
    /// sets current duedate by checken current with array
    static func dueDate() {
        for date in self.cleaningDates {
            if Date() < date {
                self.cleaningDue = date
                break
            }
        }
    }
}
