//
//  ExerciseListToolbar.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.05.24.
//

import Foundation
import SwiftUI

struct ExerciseListToolbar: ToolbarContent {
    
    let workout: Workout
    
    let onAddExercise: () -> ()
    let onEditWorkout: () -> ()
    
    init(workout: Workout, onAddExercise: @escaping () -> (), onEditWorkout: @escaping () -> ()) {
        self.workout = workout
        self.onAddExercise = onAddExercise
        self.onEditWorkout = onEditWorkout
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack {
                Icon(sfSymbol: workout.sfSymbol, color: ColorScheme.ICON_COLOR(Int(workout.colorIndex)), small: true)
                Text(workout.name)
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
            EditButton()
        }
        
        ToolbarItem {
            HStack {
                Button(action: {
                    onAddExercise()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
