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
    var exercises: [Exercise] = []
    
    @Published
    var selectedExercise = Exercise()
    
    @Published
    var editedExercise = Exercise()
    
    @Published
    var isCreateSheetPresented = false
    
    @Published
    var isEditSheetPresented = false
    
    @Published
    var exerciseTracker = ExerciseTracker.instance
    
    @Published
    var isRunning = false
    
    @Published
    var runningExercise: Exercise? = nil
    
    @Published
    var progress: Double = 0.0
        
    func start() {
        self.isRunning = true
        exerciseTracker.start(exercises, onFinish: {
            DispatchQueue.main.async {
                self.isRunning = false
            }
        }, onUpdate: { runningExercise, progress in
            DispatchQueue.main.async {
                self.runningExercise = runningExercise
                if runningExercise != nil {
                    self.progress = progress
                }
            }
        })
    }
    
    func stop() {
        exerciseTracker.stop()
        isRunning = false
    }
    
    func onAddExercise() {
        editedExercise = Exercise()
        editedExercise.sortIndex = (exercises.last?.sortIndex ?? -1) + 1
        isCreateSheetPresented = true
    }
    
    func onCreateExercise(workout: Workout) {
        isCreateSheetPresented = false
        exercises.append(editedExercise)
        editedExercise.workout = workout
    }
    
    func hideExerciseCreateSheet() {
        isCreateSheetPresented = false
    }
    
    func onEditExercise(_ exercise: Exercise) {
        if !isRunning {
            selectedExercise = exercise
            editedExercise = Exercise()
            editedExercise.copyValues(from: exercise)
            isEditSheetPresented = true
        }
    }
    
    func onUpdateExercise() {
        isEditSheetPresented = false
        selectedExercise.copyValues(from: editedExercise)
    }
    
    func hideExerciseEditSheet() {
        isEditSheetPresented = false
    }
    
    func onMoveExercise(indexSet: IndexSet, newPosition: Int) {
        if !isRunning {
            exercises.move(fromOffsets: indexSet, toOffset: newPosition)
            exercises.enumerated().forEach({ index, exercise in
                exercise.sortIndex = index
            })
        }
    }
    
    func onDeleteExercise(indexSet: IndexSet) {
        exercises.remove(atOffsets: indexSet)
    }
}
