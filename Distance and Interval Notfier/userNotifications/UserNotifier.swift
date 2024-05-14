//
//  UserNotifier.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import UserNotifications

class UserNotifier {
    
    private let notificationSoundGenerator = NotificationSoundGenerator()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func notify(amount: Double, unit: Unit) async {
        userNotificationCenter.removeAllDeliveredNotifications()
        
        do {
            try await self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            Log.error("Error requesting user notificaton authorization", error)
            return
        }
        
        let content = UNMutableNotificationContent()
        let uuid = UUID()
        content.title = "Exercise"
        content.body = "\(Int(amount)) \(unit)"
        content.sound = await notificationSoundGenerator.generateNotificationSound(uuid: uuid, amount: amount, unit: unit)
        
        let request: UNNotificationRequest
        if unit.quantity == .TIME {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Converter.toSeconds(amount, from: unit), repeats: false)
            request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)
        } else {
            request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: nil)
        }
        
        do {
            try await self.userNotificationCenter.add(request)
        } catch {
            Log.error("Error adding user notification", error)
        }
    }
    
    func cancel() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
