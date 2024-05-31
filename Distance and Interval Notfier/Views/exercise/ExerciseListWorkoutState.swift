//
//  ExerciseListWorkoutState.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 20.05.24.
//

import Foundation
import SwiftUI

class ExerciseListWorkoutState: ObservableObject {
    
    @Published
    var workout = Workout()
        
    @Published
    var editedWorkout = Workout()
    
    @Published
    var isWorkoutEditSheetPresented = false
       
    func onEditWorkout() {
        editedWorkout.copyValues(from: workout)
        isWorkoutEditSheetPresented = true
    }
    
    func onUpdateWorkout() {
        isWorkoutEditSheetPresented = false
        workout.copyValues(from: editedWorkout)
    }
    
    func hideWorkoutEditSheet() {
        isWorkoutEditSheetPresented = false
    }
}
