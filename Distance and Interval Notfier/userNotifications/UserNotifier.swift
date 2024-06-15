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
    
    func notify(_ delay: TimeInterval, _ title: String, _ seconds: Double, _ minutes: Double?, _ hours: Double?) async {
        await prepareNotificationRequest()
        let uuid = UUID()
        let sound = await notificationSoundGenerator.generateNotificationSound(uuid, seconds, minutes, hours)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let body = buildTimeBody(seconds, minutes, hours)
        await requestNotification(uuid, title, body, sound, trigger)
    }
    
    func notify(_ title: String, _ meters: Double, _ kilometers: Double?) async {
        await prepareNotificationRequest()
        let uuid = UUID()
        let sound = await notificationSoundGenerator.generateNotificationSound(uuid, meters, kilometers)
        let body = buildDistanceBody(meters, kilometers)
        await requestNotification(uuid, title, body, sound, nil)
    }
    
    func notify(_ title: String, _ meters: Double, _ kilometers: Double?, _ seconds: Double, _ minutes: Double?, _ hours: Double?) async {
        await prepareNotificationRequest()
        let uuid = UUID()
        let sound = await notificationSoundGenerator.generateNotificationSound(uuid, meters, kilometers, seconds, minutes, hours)
        let body = buildDistanceBody(meters, kilometers) + ", " + buildTimeBody(seconds, minutes, hours)
        await requestNotification(uuid, title, body, sound, nil)
    }
    
    func notify(_ title: String, _ seconds: Double, _ minutes: Double?, _ hours: Double?, _ meters: Double, _ kilometers: Double?) async {
        await prepareNotificationRequest()
        let uuid = UUID()
        let sound = await notificationSoundGenerator.generateNotificationSound(uuid, seconds, minutes, hours, meters, kilometers)
        let body = buildTimeBody(seconds, minutes, hours) + ", " + buildDistanceBody(meters, kilometers) 
        await requestNotification(uuid, title, body, sound, nil)
    }
    
    func notifyOpenApp(_ title: String, _ delay: Double) async {
        let uuid = UUID()
        let sound = await notificationSoundGenerator.generateOpenAppSound(uuid)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        await requestNotification(uuid, title, "Open the app to continue!", sound, trigger)
    }
    
    func cancel() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func buildTimeBody(_ seconds: Double, _ minutes: Double?, _ hours: Double?) -> String {
        var body = ""
        if let hours = hours {
            body.append("\(Int(hours)) \(String(describing: Unit.HOUR)), ")
        }
        if let minutes = minutes {
            body.append("\(Int(minutes)) \(String(describing: Unit.MINUTE)), ")
        }
        body.append("\(Int(seconds)) \(String(describing: Unit.SECOND))")
        return body
    }
    
    private func buildDistanceBody(_ meters: Double, _ kilometers: Double?) -> String {
        var body = ""
        if let kilometers {
            body.append("\(Int(kilometers)) \(String(describing: Unit.KILOMETER)), ")
        } else if meters == 0 {
            return "Error building message body"
        }
        
        body.append("\(Int(meters)) \(String(describing: Unit.METER))")
        
        return body
    }
    
    private func prepareNotificationRequest() async {
        do {
            try await userNotificationCenter.requestAuthorization(options: [.alert, .sound])
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
            try await userNotificationCenter.add(request)
        } catch {
            Log.error("Error adding user notification", error)
        }
    }
}
