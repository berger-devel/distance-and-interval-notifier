//
//  AmountFormatter.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 12.09.22.
//

import Foundation

struct AmountFormatter {
    private let numberFormatter: NumberFormatter
    
    init() {
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.minimumFractionDigits = 0
        self.numberFormatter.maximumFractionDigits = 3
    }
    
    func string(from amount: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
}
