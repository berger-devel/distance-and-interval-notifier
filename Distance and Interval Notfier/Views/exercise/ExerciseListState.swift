//
//  ExerciseListState.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 17.05.24.
//

import Foundation
import SwiftData

class ExerciseListState: ObservableObject {
    
    @Published
    var selectedExercise = Exercise()
    
    @Published
    var editedExercise = Exercise()
    
    @Published
    var isCreateSheetPresented = false
    
    @Published
    var isEditSheetPresented = false
    
    @Published
    var editedWorkout = Workout()
    
    @Published
    var isWorkoutEditSheetPresented = false
    
    @Published
    var exerciseTracker = ExerciseTracker()
    
    @Published
    var isRunning = false
    
    @Published
    var progress = 0.0
        
    func start(_ exercises: [Exercise]) {
        self.isRunning = true
        exerciseTracker.start(exercises, onFinish: {
            DispatchQueue.main.async {
                self.isRunning = false
            }
        }, onUpdate: { progress in
            DispatchQueue.main.async {
                self.progress = progress
            }
        })
    }
    
    func stop() {
        exerciseTracker.stop()
        isRunning = false
    }
}
