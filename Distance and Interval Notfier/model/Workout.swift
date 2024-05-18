//
//  Workout.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.05.24.
//

import Foundation
import SwiftData

@Model
class Workout {
    
    var name: String 
    var sfSymbol: String
    var colorIndex: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout)
    var exercises: [Exercise]
    
    var sortIndex: Int
    
    init() {
        name = "New Workout"
        sfSymbol = "bicycle"
        colorIndex = 0
        exercises = []
        sortIndex = 0
    }
    
    func copyValues(from workout: Workout) {
        name = workout.name
        sfSymbol = workout.sfSymbol
        colorIndex = workout.colorIndex
    }
}
