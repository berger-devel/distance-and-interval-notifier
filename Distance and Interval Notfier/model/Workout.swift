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
    
    @Attribute
    var appearance: Appearance
    
    var sortIndex: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout)
    var exercises: [Exercise]
    
    init() {
        appearance = Appearance(name: "New Workout", sfSymbol: "bicycle", colorIndex: 0)
        sortIndex = 0
        exercises = []
    }
    
    func copyValues(from workout: Workout) {
        appearance = workout.appearance
    }
}
