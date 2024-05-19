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
    
    func notify(delay: TimeInterval, title: String, seconds: Double, minutes: Double?, hours: Double?) async {
        await prepareNotificationRequest()
        
        let uuid = UUID()
        
        var body = ""
        if let hours = hours {
            body.append("\(Int(hours)) \(String(describing: Unit.HOUR)), ")
        }
        if let minutes = minutes {
            body.append("\(Int(minutes)) \(String(describing: Unit.MINUTE)), ")
        }
        body.append("\(Int(seconds)) \(String(describing: Unit.SECOND))")

        let sound = await notificationSoundGenerator.generateNotificationSound(uuid, seconds, minutes, hours)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        await requestNotification(uuid, title, body, sound, trigger)
    }
    
    func notify(title: String, meters: Double, kilometers: Double?) async {
        await prepareNotificationRequest()
        
        let uuid = UUID()
        
        var body = ""
        if let kilometers = kilometers {
            body.append("\(Int(kilometers)) \(String(describing: Unit.KILOMETER)), ")
        }
        body.append("\(Int(meters)) \(String(describing: Unit.METER))")
        
        let sound = await notificationSoundGenerator.generateNotificationSound(uuid, meters, kilometers)
        
        await requestNotification(uuid, title, body, sound, nil)
    }
    
    func cancel() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func prepareNotificationRequest() async {
        userNotificationCenter.removeAllDeliveredNotifications()
        
        do {
            try await self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            Log.error("Error requesting user notificaton authorization", error)
            return
        }
    }
    
    private func requestNotification(_ uuid: UUID, _ title: String, _ body: String, _ sound: UNNotificationSound, _ trigger: UNTimeIntervalNotificationTrigger?) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)
        
        do {
            try await self.userNotificationCenter.add(request)
        } catch {
            Log.error("Error adding user notification", error)
        }
    }
}
