//
//  WorkoutListItem.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 18.08.22.
//

import Foundation
import SwiftUI
import CoreData

struct WorkoutListItem: View {
    
    @State
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    var body: some View {
        HStack(spacing: Constants.WORKOUT_LIST_SPACING) {
            Icon(sfSymbol: workout.appearance.sfSymbol, color: ColorScheme.ICON_COLOR(Int(workout.appearance.colorIndex)))
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(workout.appearance.name)
                        .fontWeight(Constants.BOLD)
                    Spacer()
                }
                
                HStack {
                    Text("\(workout.exercises.count) exercises")
                    Spacer()
                }
                
                Spacer()
            }
        }
        .frame(maxHeight: Constants.WORKOUT_LIST_ITEM_HEIGHT)
    }
}
