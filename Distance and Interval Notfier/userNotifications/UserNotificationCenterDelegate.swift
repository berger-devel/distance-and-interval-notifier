//
//  UserNotificationDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.08.22.
//

import Foundation
import UserNotifications

class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ExerciseTracker.instance.nextExerciseGroup(nextExerciseIndex: response.notification.request.content.userInfo["NEXT_EXERCISE_INDEX"] as! Int)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
