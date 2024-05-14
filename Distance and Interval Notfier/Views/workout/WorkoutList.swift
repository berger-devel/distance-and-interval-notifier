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
                    if let index = indexSet.first {
                        persistenceManager.delete(workouts[index], context)
                    }
                }
                .onMove(perform: { indexSet, newPosition in
                    persistenceManager.move(indexSet, to: newPosition, context)
                    selectedWorkout = nil
                })
            }
            .navigationTitle("My Workouts")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            isEditSheetPresented = true
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
                            do {
                                guard let exercises = workout.exercises else {
                                    throw OptionalError.from("exercises")
                                }
                                
                                return try exercises.map({ exercise in
                                    guard let exercise = exercise as? Exercise else {
                                        throw OptionalError.from("exercise")
                                    }
                                    return UIExercise(from: exercise)
                                })
                            } catch {
                                Log.error("Error getting exercises", error)
                                return []
                            }
                        },
                        set: { exercises in
                            do {
                                guard let exercises = workout.exercises?.array as? [Exercise] else {
                                    throw OptionalError.from("exercises")
                                }
                                
                                exercises.forEach({ exercise in context.delete(exercise) })
                                workout.exercises = NSOrderedSet(array: exercises)
                                PersistenceHelper.commit(context, errorLogMessage: "Failed to update exercises of workout")
                            } catch {
                                Log.error("Error setting exercises", error)
                            }
                        }
                    ),
                    formerValues: {
                        do {
                            guard let exercises = workout.exercises?.array as? [Exercise] else {
                                throw OptionalError.from("exercises")
                            }
                            
                            return try exercises.reduce(into: [:], { dict, exercise in
                                guard let id = exercise.id else {
                                    throw OptionalError.from("id")
                                }
                                
                                return dict[id] = UIExercise(from: exercise)
                            })
                        } catch {
                            return [:]
                        }
                    } ()
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
