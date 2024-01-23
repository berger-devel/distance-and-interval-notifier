//
//  MeterFormatter.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 17.08.22.
//

import Foundation
import os


struct Formatters {
    static let meterFormatter = MeterFormatter()
    
    struct MeterFormatter {
        private let numberFormatter: NumberFormatter
        
        init() {
            numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 0
        }
        
        func string(from d: Double) -> String {
            guard let string = numberFormatter.string(from: NSNumber(value: d)) else {
                Logger().error("Failed to parse \(d) as value for meter")
                return "0"
            }
            
            return string
        }
    }
}
