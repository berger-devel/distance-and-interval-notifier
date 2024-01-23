//
//  ExercisePersistenceManager.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 01.10.22.
//

import Foundation
import CoreData

class ExercisePersistenceManager {
    
    func add(_ newExercise: UIExercise, to workout: Workout, _ context: NSManagedObjectContext) {
        Exercise(selectedExercise: newExercise, context: context).workout = workout
        PersistenceHelper.commit(context, errorLogMessage: "Failed to persist new exercise")
    }
    
    func update(_ selectedExercise: UIExercise, of workout: Workout, _ context: NSManagedObjectContext) {
        var exercises = workout.exercises!.array as! [Exercise]
        let exerciseIndex = exercises.firstIndex(where: { exercise in exercise.id! == selectedExercise.exerciseId })!
        let oldExercise = exercises[exerciseIndex]
        exercises[exerciseIndex] = Exercise(selectedExercise: selectedExercise, context: context)
        workout.exercises = NSOrderedSet(array: exercises)
        context.delete(oldExercise)
        PersistenceHelper.commit(context, errorLogMessage: "Failed to persist exercises")
    }
    
    func delete(_ exercise: Exercise, of workout: Workout, _ context: NSManagedObjectContext) {
        context.delete(exercise)
        PersistenceHelper.commit(context, errorLogMessage: "Failed to delete exercise")
    }
}
