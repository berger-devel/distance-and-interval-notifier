//
//  ExerciseExt.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.09.22.
//

import Foundation
import CoreData
import SwiftUI

extension Exercise {
    
    convenience init(selectedExercise: UIExercise, context: NSManagedObjectContext) {
        self.init(context: context)
        update(from: selectedExercise)
    }
    
    @discardableResult
    func update(from selectedExercise: UIExercise) -> Exercise {
        name = selectedExercise.name
        sfSymbol = selectedExercise.sfSymbol
        colorIndex = Int16(selectedExercise.colorIndex)
        unit = Int16(selectedExercise.unit.rawValue)
        amount = Float(selectedExercise.amount)
        notificationFrequency = selectedExercise.notificationFrequency.rawValue
        announceBothQuantities = selectedExercise.announceBothQuantities
        return self
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

struct UIExercise: Hashable, Equatable {
    
    var exerciseId = UUID()
    var name = "New Exercise"
    var sfSymbol = "bicycle"
    var colorIndex = 1
    var amount = Constants.TIME_AMOUNTS_SECOND[0]
    var changedAmount = Constants.TIME_AMOUNTS_SECOND[0]
    var unit = Unit.SECOND
    var quantity = Quantity.TIME
    var notificationFrequency = NotificationFrequency.ONCE
    var announceBothQuantities = false
    var sortIndex = 0
    var completed = false
    
    init() { }
    
    init(from exercise: Exercise) {
        exerciseId = exercise.id!
        name = exercise.name!
        sfSymbol = exercise.sfSymbol!
        colorIndex = Int(exercise.colorIndex)
        amount = Double(exercise.amount)
        changedAmount = Double(exercise.amount)
        unit = Unit(rawValue: Int(exercise.unit))!
        quantity = unit.quantity
        notificationFrequency = NotificationFrequency(rawValue: exercise.notificationFrequency)!
        announceBothQuantities = exercise.announceBothQuantities
        completed = false
    }
}
