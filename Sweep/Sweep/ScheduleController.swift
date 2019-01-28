//
//  ScheduleController.swift
//  Sweep
//
//  Created by Sander de Vries on 24/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Calculates schedule based on the hardcoded reference date
//  Rearranges the residents array to schedule everyone equally
//

import Foundation


struct ScheduleController {
    
    static var doneRearranging = false
    
    // weeknumber of reference date
    static var firstweek: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let firstDate = DateComponents.cleaningDates.first!
        print("first \(calendar.component(.weekOfYear, from: firstDate))")
        return calendar.component(.weekOfYear, from: firstDate)
    }
    
    /// calcs current weeknumber
    static func calcCurrentWeek() -> Int {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        print("current: \(calendar.component(.weekOfYear, from: currentDate))")
        return calendar.component(.weekOfYear, from: currentDate)
    }
    
    /// rearranges residents array based on difference in week number
    static func rearrangePeople() {
        let oldWeekday = ScheduleController.firstweek
        let currentWeek = ScheduleController.calcCurrentWeek()
        let weekDifference = currentWeek - oldWeekday
        
        
        print(HouseModelController.residents)
        guard ChoreModelController.chores.count > 0 else { return }
        
        // rearrange if difference is greater than 0
        if weekDifference > 0 {
            
            // move first resident to the last index
            for _ in 1...weekDifference {
                for _ in 1...ChoreModelController.chores.count {
                    let first = HouseModelController.residents.removeFirst()
                    HouseModelController.residents.append(first)
                }
            }
            
            doneRearranging = true
        }
    }
}
