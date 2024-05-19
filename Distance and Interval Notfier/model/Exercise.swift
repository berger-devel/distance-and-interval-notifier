//
//  Exercise.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.05.24.
//

import Foundation
import SwiftData

@Model
class Exercise: Comparable {
    
    var appearance: Appearance
    
    var sortIndex: Int
    
    var amount: Double
    var unit: Unit
    var notificationFrequency: NotificationFrequency
    var announceBothQuantities: Bool
    var repetitionFrequency: Int
    
    var workout: Workout?
    
    static func < (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.sortIndex < rhs.sortIndex
    }

    init() {
        appearance = Appearance(name: "New Exercise", sfSymbol: "bicycle", colorIndex: 0)
        sortIndex = 0
        amount = Constants.TIME_AMOUNTS_SECOND[0]
        unit = .SECOND
        notificationFrequency = .ONCE
        announceBothQuantities = false
        repetitionFrequency = Constants.REPETITION_AMOUNTS[0]
    }
    
    func copyValues(from exercise: Exercise) {
        appearance = exercise.appearance
        amount = exercise.amount
        unit = exercise.unit
        notificationFrequency = exercise.notificationFrequency
        announceBothQuantities = exercise.announceBothQuantities
        repetitionFrequency = exercise.repetitionFrequency
    }
}
