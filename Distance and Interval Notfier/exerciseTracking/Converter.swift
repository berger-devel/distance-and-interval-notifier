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
}
