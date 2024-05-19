//
//  NotificationFrequency.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 17.05.24.
//

import Foundation

enum NotificationFrequency: Int, CustomStringConvertible, CaseIterable, Codable {
    static func from(_ ordinal: Int) -> NotificationFrequency {
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
}
