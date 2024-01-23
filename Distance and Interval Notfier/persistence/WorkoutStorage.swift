//
//  WorkoutStorage.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 19.08.22.
//

import Foundation
import CoreData
import os
import SwiftUI

class WorkoutStorage: ObservableObject {
    
    static let workoutSortDescriptors = [NSSortDescriptor(keyPath: \Workout.sortIndex, ascending: true)]
    
    static let shared = WorkoutStorage()
    static let preview: WorkoutStorage = {
        let preview = WorkoutStorage(inMemory: true)
        PreviewWorkouts.twoWorkoutsThreeExercises(preview.persistentContainer.viewContext)
        return preview
    }()
    
    let persistentContainer: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "workouts")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores {(_, error) in
            if let error = error as NSError? {
                Logger().error("Failed to load persistent stores \(error.localizedDescription)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}
