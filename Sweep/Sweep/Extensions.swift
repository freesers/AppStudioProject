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

extension DateComponents {
    
    static var cleaningDayComponent = DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2019, month: 1, day: 27, hour: 23, minute: 59, second: 59, nanosecond: nil, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    
    static var firstCleaningDate = Calendar.current.date(from: DateComponents.cleaningDayComponent)
    
    static var cleaningDates = [Date]()
    
    static var cleaningDue = Date()
    
    static func createDates() {
        
        for _ in 1...100 {
            let date = DateComponents.firstCleaningDate!
            DateComponents.cleaningDates.append(date)
            self.firstCleaningDate = firstCleaningDate?.addingTimeInterval(60 * 60 * 24 * 7)
        }
    }
    
    static func dueDate() {
        for date in self.cleaningDates {
            if Date() < date {
                self.cleaningDue = date
                break
            }
        }
    }
}
