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
        do {
            guard var exercises = workout.exercises?.array as? [Exercise] else {
                throw OptionalError.from("exercises")
            }
            
            if let exerciseIndex = try exercises.firstIndex(where: { exercise in
                guard let id = exercise.id else {
                    throw OptionalError.from("id")
                }
                
                return id == selectedExercise.exerciseId
            }) {
                let oldExercise = exercises[exerciseIndex]
                exercises[exerciseIndex] = Exercise(selectedExercise: selectedExercise, context: context)
                workout.exercises = NSOrderedSet(array: exercises)
                context.delete(oldExercise)
                PersistenceHelper.commit(context, errorLogMessage: "Failed to persist exercises")
            }
        } catch {
            Log.error("Error updating exercise", error)
        }
    }
    
    func move(_ indexSet: IndexSet, of workout: Workout, to newIndex: Int, _ context: NSManagedObjectContext) {
        do {
            guard let mutableOrderedSet: NSMutableOrderedSet = workout.exercises?.mutableCopy() as? NSMutableOrderedSet else {
                throw OptionalError.from("mutableOrderedSet")
            }
            
            var reorderedExercises = mutableOrderedSet.array
            reorderedExercises.move(fromOffsets: indexSet, toOffset: newIndex)
            workout.exercises = NSOrderedSet(array: reorderedExercises)
            PersistenceHelper.commit(context, errorLogMessage: "Failed to re-order workouts")
        } catch {
            Log.error("Error moving exercise", error)
        }
    }
    
    func delete(_ exercise: Exercise, of workout: Workout, _ context: NSManagedObjectContext) {
        context.delete(exercise)
        PersistenceHelper.commit(context, errorLogMessage: "Failed to delete exercise")
    }
}
