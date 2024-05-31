//
//  WorkoutList.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 18.08.22.
//

import Foundation
import SwiftUI
import SwiftData

struct WorkoutList: View {
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.editMode)
    private var editMode
    
    @Query(sort: \Workout.sortIndex)
    private var workouts: [Workout] = []
    
    @State
    private var selectedWorkout: Workout?
    
    @State
    private var selectedExercise: Exercise?
    
    @State
    private var isCreateSheetPresented = false
    
    @State
    private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedWorkout) {
                ForEach(workouts, id: \.self) { workout in
                    NavigationLink(value: workout) {
                        WorkoutListItem(workout: workout)
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        modelContext.delete(workouts[index])
                    }
                }
                .onMove{ indexSet, newPosition in
                    var reorderedWorkouts = workouts
                    reorderedWorkouts.move(fromOffsets: indexSet, toOffset: newPosition)
                    reorderedWorkouts.enumerated().forEach({ index, workout in
                        workout.sortIndex = index
                    })
                }
            }
            .navigationTitle("My Workouts")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            selectedWorkout = Workout()
                            selectedWorkout?.sortIndex = (workouts.last?.sortIndex ?? -1) + 1
                            isCreateSheetPresented = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                            Text("New Workout")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .sheet(isPresented: $isCreateSheetPresented) {
                NavigationStack {
                    WorkoutEditSheet(Binding(get: { selectedWorkout }, set: { _ in }), onDone: {
                        isCreateSheetPresented = false
                        modelContext.insert(selectedWorkout!)
                    }, onCancel: {
                        isCreateSheetPresented = false
                        selectedWorkout = nil
                    })
                }
            }
        } detail: {
            if let workout = selectedWorkout {
                ExerciseList(workout: Binding(get: { workout }, set: { _ in }))
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
