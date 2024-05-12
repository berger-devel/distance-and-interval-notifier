//
//  UserNotifier.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import UserNotifications
import os

class UserNotifier {
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func notify(exercise: UIExercise, interval: Double? = nil) {
        self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [self] granted, error in
            if let error = error {
                Logger().error("Failed to authorize for notification: \(error.localizedDescription)")
            } else {
                let content = UNMutableNotificationContent()
                content.title = "bla"
                content.body = "test"
                content.sound = .default

                let request: UNNotificationRequest
                if let timeInterval = interval {
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                    request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                } else {
                    request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                }
                self.userNotificationCenter.add(request)
            }
        }
    }
    
    func cancel() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
