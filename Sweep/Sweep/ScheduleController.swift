//
//  ScheduleController.swift
//  Sweep
//
//  Created by Sander de Vries on 24/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation

struct ScheduleController {
    
    static var firstweek: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let firstDate = DateComponents.cleaningDates.first!
        print("first \(calendar.component(.weekOfYear, from: firstDate))")
        return calendar.component(.weekOfYear, from: firstDate)
    }
    
    static func calcCurrentWeek() -> Int {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        print("current: \(calendar.component(.weekOfYear, from: currentDate))")
        return calendar.component(.weekOfYear, from: currentDate)
    }
    
    static func rearrangePeople() {
        let oldWeekday = ScheduleController.firstweek
        let currentWeek = ScheduleController.calcCurrentWeek()
        let weekDifference = currentWeek - oldWeekday
        print(weekDifference)
        
        if weekDifference > 0 {
            for _ in 1...weekDifference {
                for _ in 1...ChoreModelController.chores.count {
                    let first = HouseModelController.residents.removeFirst()
                    HouseModelController.residents.append(first)
                }
            }
        }
    }
    
    
}
