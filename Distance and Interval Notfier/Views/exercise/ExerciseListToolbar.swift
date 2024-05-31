//
//  ExerciseListToolbar.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.05.24.
//

import Foundation
import SwiftUI

struct ExerciseListToolbar: ToolbarContent {
    
    private let workout: Workout
    private let onEditWorkout: () -> ()
    
    @ObservedObject
    private var exerciseListState: ExerciseListState
    
    init(exerciseListState: ExerciseListState, workout: Workout, onEditWorkout: @escaping () -> ()) {
        self.workout = workout
        self.onEditWorkout = onEditWorkout
        self.exerciseListState = exerciseListState
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack {
                Icon(sfSymbol: workout.appearance.sfSymbol, color: ColorScheme.ICON_COLOR(Int(workout.appearance.colorIndex)), small: true)
                Text(workout.appearance.name)
                    .lineLimit(1)
            }
        }
        
        ToolbarItem {
            Button(action: {
                onEditWorkout()
            }) {
                Image(systemName: "square.and.pencil")
            }
        }
        
        ToolbarItem {
            ExerciseListConditionalToolbarItem(isHidden: $exerciseListState.isRunning) {
                EditButton()
            }
        }
        
        ToolbarItem {
            ExerciseListConditionalToolbarItem(isHidden: $exerciseListState.isRunning) {
                HStack {
                    Button(action: {
                        exerciseListState.onAddExercise()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
