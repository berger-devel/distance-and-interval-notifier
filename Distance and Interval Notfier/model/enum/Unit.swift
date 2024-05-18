//
//  Unit.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.05.24.
//

import Foundation

enum Unit: CustomStringConvertible, Codable {
    
    case SECOND, MINUTE, HOUR,
         METER, KILOMETER, MILE
    
    var quantity: Quantity {
        get {
            switch(self) {
            case .SECOND, .MINUTE, .HOUR: .TIME
            default: .DISTANCE
            }
        }
        set { }
    }
    
    var description: String {
        switch self {
        case .SECOND: "Seconds"
        case .MINUTE: "Minutes"
        case .HOUR: "Hours"
        case .METER: "Meters"
        case .KILOMETER: "Kilometers"
        case .MILE: "Miles"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .SECOND: "sec"
        case .MINUTE: "min"
        case .HOUR: "h"
        case .METER: "m"
        case .KILOMETER: "km"
        case .MILE: "mi"
        }
    }
}
