//
//  Exercise.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.05.24.
//

import Foundation
import SwiftData

@Model
class Exercise {
    
    var name: String
    var amount: Double
    var unit: Unit
    var notificationFrequency: NotificationFrequency
    var announceBothQuantities: Bool
    var sfSymbol: String
    var colorIndex: Int
    
    var workout: Workout?
    
    var sortIndex: Int
    
    init() {
        name = "New Exercise"
        amount = Constants.TIME_AMOUNTS_SECOND[0]
        unit = .SECOND
        notificationFrequency = .ONCE
        announceBothQuantities = false
        sfSymbol = "bicycle"
        colorIndex = 0
        sortIndex = 0
    }
    
    func copyValues(from exercise: Exercise) {
        name = exercise.name
        amount = exercise.amount
        unit = exercise.unit
        notificationFrequency = exercise.notificationFrequency
        announceBothQuantities = exercise.announceBothQuantities
        sfSymbol = exercise.sfSymbol
        colorIndex = exercise.colorIndex
    }
}
