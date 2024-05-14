//
//  WorkoutExt.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 26.08.22.
//

import Foundation
import SwiftUI
import CoreData

extension Workout {
    static func from(_ current: CurrentWorkout, context: NSManagedObjectContext) -> Workout {
        let workout = Workout(context: context)
        workout.name = current.name
        workout.sfSymbol = current.sfSymbol
        workout.colorIndex = Int16(current.colorIndex)
        return workout
    }
    
    func update(from updatedWorkout: CurrentWorkout) {
        name = updatedWorkout.name
        sfSymbol = updatedWorkout.sfSymbol
        colorIndex = Int16(updatedWorkout.colorIndex)
    }
    
    func updateView() {
        self.objectWillChange.send()
    }
}

struct CurrentWorkout {
    static func from(_ workout: Workout) -> CurrentWorkout {
        do {
            guard let name = workout.name else {
                throw OptionalError.from("name")
            }
            
            guard let sfSymbol = workout.sfSymbol else {
                throw OptionalError.from("sfSymbol")
            }
            
            return CurrentWorkout(name: name, sfSymbol: sfSymbol, colorIndex: Int(workout.colorIndex))
        } catch {
            Log.error("Error creating current workout", error)
            return CurrentWorkout()
        }
    }
    
    var name = "New Workout"
    var sfSymbol = "calendar"
    var colorIndex: Int  = 0
}
