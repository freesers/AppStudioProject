//
//  NotificationController.swift
//  Sweep
//
//  Created by Sander de Vries on 25/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Manages the creation of local push notifications
//

import Foundation
import UserNotifications


struct NotificationController {
    
    // one shared instance to keep track of all notifications
    static let shared = UNUserNotificationCenter.current()
    
    /// setup notification (Saterday 5 PM)
    func setupUN() {
        
        // create content
        let content = UNMutableNotificationContent()
        content.title = "Have you done your chore yet?"
        content.body = "You're up this weekend"
        
        // create date component
        var dateComponent = DateComponents()
        dateComponent.calendar = Calendar.current
        dateComponent.weekday = 7
        dateComponent.hour = 17
        
        // create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        // create request with identifier, content and trigger info
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        NotificationController.shared.add(request, withCompletionHandler: nil)
    }
    
    // creates test notification, 30 seconds from now
    func setupTestUN() {
        
        // create content
        let content = UNMutableNotificationContent()
        content.title = "Have you done your chore yet? - test"
        content.body = "You're up this weekend"
        
        // create date component, 30 seconds from now
        let date = Date().addingTimeInterval(30)
        print("alert at: \(date)")
        let calendar = Calendar.current
        let datecomponent = calendar.dateComponents([.hour, .minute, .second] ,from: date)
        
        // create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: false)
        
        // create request with identifier, content and trigger info
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        NotificationController.shared.add(request, withCompletionHandler: nil)
    }
    
    /// check if user has chore to do
    func checkIfUserIsUp(usersDue: [String]) {
        let currentUser = UserModelController.currentUser.name
        
        // check if current user is due
        if usersDue.contains(currentUser) {
            NotificationController.shared.getPendingNotificationRequests { (notifications) in
                
                // if returned array is empty, no notification has been set
                if notifications.isEmpty {
                    self.setupUN()
                } else {
                    //self.setupTestUN()
                    //print(notifications.count)
                }
            }
        }
    }
}
