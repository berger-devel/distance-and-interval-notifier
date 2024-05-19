//
//  ExerciseList.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.08.22.
//

import Foundation
import SwiftUI
import SwiftData

struct ExerciseList: View {
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @Environment(\.editMode)
    private var editMode
    
    let workout: Workout
    
    @StateObject
    private var state = ExerciseListState()
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    ColorScheme.BACKGROUND_COLOR(colorScheme).ignoresSafeArea(.all)
                    List {
                        ForEach(workout.exercises.sorted()) { exercise in
                            Button(action: {
                                state.selectedExercise = exercise
                                state.editedExercise = Exercise()
                                state.editedExercise.copyValues(from: exercise)
                                state.isEditSheetPresented = true
                            }) {
                                ExerciseListItem(exercise, $state.progress)
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                modelContext.delete(workout.exercises[index])
                            }
                        }
                        .onMove(perform: { indexSet, newPosition in
                            var reorderedExercises = workout.exercises.sorted()
                            reorderedExercises.move(fromOffsets: indexSet, toOffset: newPosition)
                            reorderedExercises.enumerated().forEach({ index, exercise in
                                exercise.sortIndex = index
                            })
                        })
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ExerciseListToolbar(workout: workout, onAddExercise: {
                            state.editedExercise = Exercise()
                            state.editedExercise.sortIndex = (workout.exercises.sorted().last?.sortIndex ?? -1) + 1
                            state.isCreateSheetPresented = true
                        }, onEditWorkout: {
                            state.editedWorkout.copyValues(from: workout)
                            state.isWorkoutEditSheetPresented = true
                        })
                    }
                    .sheet(isPresented: $state.isCreateSheetPresented) {
                        ExerciseEditSheet($state.editedExercise, onDone: {
                            state.isCreateSheetPresented = false
                            modelContext.insert(state.editedExercise)
                            state.editedExercise.workout = workout
                        }, onCancel: {
                            state.isCreateSheetPresented = false
                        })
                    }
                    .sheet(isPresented: $state.isEditSheetPresented) {
                        ExerciseEditSheet($state.editedExercise, onDone: {
                            state.isEditSheetPresented = false
                            state.selectedExercise.copyValues(from: state.editedExercise)
                        }, onCancel: {
                            state.isEditSheetPresented = false
                        })
                    }
                    .sheet(isPresented: $state.isWorkoutEditSheetPresented) {
                        WorkoutEditSheet(Binding<Workout?> (get: { state.editedWorkout }, set: { _ in }), onDone: {
                            state.isWorkoutEditSheetPresented = false
                            workout.copyValues(from: state.editedWorkout)
                        }, onCancel: {
                            state.isWorkoutEditSheetPresented = false
                        })
                    }
                }
                
                if (workout.exercises).count > 0 {
                    StartButton(isRunning: $state.isRunning, start: { state.start(workout.exercises) }, stop: state.stop)
                }
            }
            .ignoresSafeArea(.container, edges: [.bottom])
        }
    }
}
