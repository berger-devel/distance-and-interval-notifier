//
//  PreviewWorkouts.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 30.09.22.
//

import Foundation
import CoreData

struct PreviewWorkouts {    
    static func twoWorkoutsThreeExercises(_ context: NSManagedObjectContext) {
        for workoutIndex in 0 ... 1 {
            let currentWorkout = CurrentWorkout(name: "Workout \(workoutIndex)", sfSymbol: "calendar", colorIndex: 0)
            let workout = Workout.from(currentWorkout, context: context)
            
            for exerciseIndex in 0 ... 2 {
                let exercise = Exercise(context: context)
                exercise.workout = workout
                exercise.name = "\(exercise.name ?? "No exercise name") \(exerciseIndex)"
            }
        }
        do {
            try context.save()
        } catch {
            print("preview error")
        }
    }
}
