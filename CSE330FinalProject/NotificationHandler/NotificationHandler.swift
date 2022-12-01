//
//  NotificationHandler.swift
//  CSE330FinalProject
//
//  Created by Ibrahim Mousa on 11/30/22.
//

import Foundation
import UserNotifications

class NotificationHandler {
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            success, error in
            if success
            {
                print("success")
            }
            else if let error = error
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification (number: String) {
        var trigger: UNNotificationTrigger?
        
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "Class \(number) has opened up"
        content.sound = UNNotificationSound.default
        
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
