//
//  NotificationController.swift
//  Sweep
//
//  Created by Sander de Vries on 25/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationController {
    
    static let shared = UNUserNotificationCenter.current()
    
    func setupUN() {
        let content = UNMutableNotificationContent()
        content.title = "Have you done your chore yet?"
        content.body = "You're up this weekend"
        
        var dateComponent = DateComponents()
        dateComponent.calendar = Calendar.current
        dateComponent.weekday = 7
        dateComponent.hour = 17
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        NotificationController.shared.add(request, withCompletionHandler: nil)
    }
    
    func setupTestUN() {
        let content = UNMutableNotificationContent()
        content.title = "Have you done your chore yet? - test"
        content.body = "You're up this weekend"
        
        let date = Date().addingTimeInterval(30)
        print("alert at: \(date)")
        let calendar = Calendar.current
        
        let datecomponent = calendar.dateComponents([.hour, .minute, .second] ,from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: false)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        NotificationController.shared.add(request, withCompletionHandler: nil)
    }
    
    func checkIfUserIsUp(users: [String]) {
        let currentUser = UserModelController.currentUser.name
        if users.contains(currentUser) {
            NotificationController.shared.getPendingNotificationRequests { (notifications) in
                if notifications.isEmpty {
                    self.setupUN()
                } else {
                   // self.setupTestUN()
                    print(notifications.count)
                }
            }
        }
    }
}
