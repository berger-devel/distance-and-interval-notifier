//
//  Converter.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 13.05.24.
//

import Foundation

class Converter {
    static func toSeconds(_ amount: Double, from: Unit) -> Double {
        return switch from {
        case .MINUTE:
            amount * 60
        case .HOUR:
            amount * 60 * 60
        default:
            amount
        }
    }
    
    static func toHours(_ seconds: Double) -> (Double, Double?, Double?) {
        let secondsOfMinute: Double
        let minutes: Double?
        let hours: Double?
        if seconds >= 60.0 {
            let min = Double(Int(seconds / 60.0))
            secondsOfMinute = seconds.truncatingRemainder(dividingBy: 60.0)
            
            if min >= 60.0 {
                hours = Double(Int(min / 60.0))
                minutes = min.truncatingRemainder(dividingBy: 60)
            } else {
                hours = nil
                minutes = min
            }
        } else {
            hours = nil
            minutes = nil
            secondsOfMinute = seconds
        }
        return (secondsOfMinute, minutes, hours)
    }
    
    static func toKilometers(_ meters: Double) -> (Double, Double?) {
        let metersOfKilometer: Double
        let kilometers: Double?
        if meters < 1000 {
            metersOfKilometer = meters
            kilometers = nil
        } else {
            metersOfKilometer = meters.truncatingRemainder(dividingBy: 1000)
            kilometers = Double(Int(meters / 1000))
        }
        
        return (metersOfKilometer, kilometers)
    }
}
