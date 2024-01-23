//
//  WorkoutPersistenceManager.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 01.10.22.
//

import Foundation
import CoreData
import SwiftUI
import os

struct WorkoutPersistenceManager {
    
    func addWorkout(_ newWorkout: CurrentWorkout, _ context: NSManagedObjectContext) {
        let workout = Workout.from(newWorkout, context: context)
        
        if let lastWorkout = fetchAllWorkouts(context).last {
            workout.sortIndex = lastWorkout.sortIndex + 1
        } else {
            workout.sortIndex = 0
        }
        PersistenceHelper.commit(context, errorLogMessage: "Failed to add workout")
    }
    
    func updateWorkout(_ workout: Workout, from currentWorkout: CurrentWorkout, _ context: NSManagedObjectContext) {
        workout.update(from: currentWorkout)
        PersistenceHelper.commit(context, errorLogMessage: "Failed to update workout")
    }
    
    func move(_ indexSet: IndexSet, to newIndex: Int, _ context: NSManagedObjectContext) {
        var reorderedWorkouts = fetchAllWorkouts(context)
        reorderedWorkouts.move(fromOffsets: indexSet, toOffset: newIndex)
        reassingSortIndices(workouts: reorderedWorkouts)
        PersistenceHelper.commit(context, errorLogMessage: "Failed to re-order workouts")
    }
    
    func delete(_ workout: Workout, _ context: NSManagedObjectContext) {
        context.delete(workout)
        PersistenceHelper.commit(context, errorLogMessage: "Failed to delete workout")

        reassingSortIndices(workouts: fetchAllWorkouts(context))
        PersistenceHelper.commit(context, errorLogMessage: "Failed to defragment workout sort indices")
    }
    
    private func fetchAllWorkouts(_ context: NSManagedObjectContext) -> [Workout] {
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        fetchRequest.sortDescriptors = WorkoutStorage.workoutSortDescriptors
        do {
            return try context.fetch(fetchRequest)
        } catch {
            PersistenceHelper.logError("Failed to fetch all workouts", error)
            return []
        }
    }
    
    private func reassingSortIndices(workouts: [Workout]) {
        var sortIndex: Int16 = 0
        workouts.forEach({ workout in
            workout.sortIndex = sortIndex
            sortIndex += 1
        })
    }
}
