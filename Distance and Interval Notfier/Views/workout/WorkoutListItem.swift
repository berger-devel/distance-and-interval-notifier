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
    
    @ObservedObject
    var workout: Workout
    
    var body: some View {
            HStack(spacing: Constants.WORKOUT_LIST_SPACING) {
                Icon(sfSymbol: workout.sfSymbol ?? "calendar", color: ColorScheme.ICON_COLOR(Int(workout.colorIndex)))
                VStack(alignment: .leading) {
                    HStack {
                        Text(workout.name ?? "NIL")
                            .fontWeight(Constants.BOLD)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("\((workout.exercises ?? []).count) exercises")
                        Spacer()
                    }
                }
            }
            .frame(maxHeight: Constants.WORKOUT_LIST_ITEM_HEIGHT)
    }
}

struct WorkoutListItemPreview: PreviewProvider {
    
    private static var workouts: [Workout] = {
        do {
            return try WorkoutStorage.preview.persistentContainer.viewContext.fetch(Workout.fetchRequest())
        } catch {
            return []
        }
    }()
    
    static var previews: some View {
        WorkoutListItem(workout: workouts.first!)
            .previewLayout(.sizeThatFits)
    }
}
