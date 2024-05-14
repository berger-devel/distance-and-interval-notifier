//
//  NotificationFrequencyPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.03.23.
//

import Foundation
import SwiftUI

struct NotificationFrequencyPicker: View {
    @Binding
    private var selectedNotificationFrequency: NotificationFrequency
    
    init(selectedNotificationFrequency: Binding<NotificationFrequency>) {
        self._selectedNotificationFrequency = selectedNotificationFrequency
    }
    
    var body: some View {
        Picker(selection: $selectedNotificationFrequency, label: Text("")) {
            Text(NotificationFrequency.ONCE.description).tag(NotificationFrequency.ONCE)
            Text(NotificationFrequency.TWICE.description).tag(NotificationFrequency.TWICE)
            Text(NotificationFrequency.THREE.description).tag(NotificationFrequency.THREE)
            Text(NotificationFrequency.FOUR.description).tag(NotificationFrequency.FOUR)
            Text(NotificationFrequency.FIVE.description).tag(NotificationFrequency.FIVE)
        }
        .pickerStyle(.wheel)
    }
}

enum NotificationFrequency: Int16, CustomStringConvertible {
    static func from(_ ordinal: Int16) -> NotificationFrequency {
        do {
            guard let notificationFrequency = NotificationFrequency(rawValue: ordinal) else {
                throw OptionalError.from("notificationFrequency")
            }
            
            return notificationFrequency
        } catch {
            Log.error("Error converting ordinal to NotificationiFrequency", error)
            return .ONCE
        }
    }
    
    case ONCE, TWICE, THREE, FOUR, FIVE
    
    var description: String {
        switch self {
        case .ONCE: return "Only when finished"
        case .TWICE: return "At half"
        case .THREE: return "Three times"
        case .FOUR: return "Four times"
        case .FIVE: return "Five times"
        }
    }
    
    enum NotificationFrequencyError: Error {
        case Ordinal
    }
}
