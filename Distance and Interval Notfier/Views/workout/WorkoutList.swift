//
//  WorkoutList.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 18.08.22.
//

import Foundation
import SwiftUI
import CoreData
import os

struct WorkoutList: View {
    
    @Environment(\.managedObjectContext)
    private var context
    
    @Environment(\.editMode)
    private var editMode

    private let persistenceManager: WorkoutPersistenceManager

    @FetchRequest(sortDescriptors: WorkoutStorage.workoutSortDescriptors)
    private var workouts: FetchedResults<Workout>

    @State
    private var newWorkout = CurrentWorkout()

    @State
    private var selectedWorkout: Workout?
    
    @State
    private var selectedExercise: Exercise?

    @State
    private var isEditSheetPresented = false
    
    @State
    private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    init() {
        persistenceManager = WorkoutPersistenceManager()
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            
            List(selection: $selectedWorkout) {
                ForEach(workouts, id: \.self) { workout in
                    NavigationLink(value: workout) {
                        WorkoutListItem(workout: workout)
                    }
                }
                .onDelete { indexSet in
                    persistenceManager.delete(workouts[indexSet.first!], context)
                }
                .onMove(perform: { indexSet, newPosition in
                    persistenceManager.move(indexSet, to: newPosition, context)
                    selectedWorkout = nil
                })
            }
            .navigationTitle("My Workouts")
            .toolbar {
//                ToolbarItem {
//                    if (workouts.count != 0) {
//                        EditButton()
//                    }
//                }

                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
//                            withAnimation(.easeIn(duration: 1000)) {
                                isEditSheetPresented = true
//                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                            Text("New Workout")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .sheet(isPresented: $isEditSheetPresented) {
                WorkoutEditSheet($newWorkout, $isEditSheetPresented) {
                    persistenceManager.addWorkout(newWorkout, context)
                }
            }
        } detail: {
            if let workout = selectedWorkout {
                ExerciseList(
                    workout: workout,
                    exercises: Binding(
                        get: {
                            return workout.exercises!.map({ exercise in UIExercise(from: exercise as! Exercise) })
                        },
                        set: { exercises in
                            (workout.exercises!.array as! [Exercise]).forEach({ exercise in context.delete(exercise) })
                            workout.exercises = NSOrderedSet(array: exercises)
                            PersistenceHelper.commit(context, errorLogMessage: "Failed to update exercises of workout")
                        }
                    ),
                    formerValues: (workout.exercises!.array as! [Exercise]).reduce(into: [:], { dict, exercise in
                        dict[exercise.id!] = UIExercise(from: exercise)
                    })
                )
            }
        }
    }
}

struct WorkoutListPreview: PreviewProvider {
    private static let context = WorkoutStorage.preview.persistentContainer.viewContext
    static var previews: some View {
        WorkoutList()
                .environment(\.managedObjectContext, context)
    }
}
