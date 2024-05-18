//
//  Quantity.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.05.24.
//

import Foundation

enum Quantity: CustomStringConvertible, Codable {
    case TIME, DISTANCE
    
    var description: String {
        switch self {
        case .TIME: "Time"
        case .DISTANCE: "Distance"
        }
    }
}
