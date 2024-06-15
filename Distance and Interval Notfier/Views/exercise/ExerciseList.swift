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
    
    @State
    private var editMode: EditMode = .inactive
    
    @Binding
    var workout: Workout
    
    @StateObject
    private var state = ExerciseListState()
    
    @StateObject
    private var workoutState = ExerciseListWorkoutState()
    
    init(workout: Binding<Workout>) {
        self._workout = workout
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                List {
                    ForEach(state.exercises) { exercise in
                        Button(action: { state.onEditExercise(exercise) }) {
                            ExerciseListItem(exercise, exerciseListState: state)
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            modelContext.delete(state.exercises[index])
                        }
                        state.onDeleteExercise(indexSet: indexSet)
                    }
                    .onMove(perform: state.onMoveExercise)
                    .deleteDisabled(state.isRunning)
                    .moveDisabled(state.isRunning)
                }
                .onAppear{
                    workoutState.workout = workout
                    state.exercises = workout.exercises.sorted()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(state.isRunning)
                .toolbar {
                    ExerciseListToolbar(exerciseListState: state, workout: workout, onEditWorkout: {
                        workoutState.onEditWorkout()
                    })
                }
                .sheet(isPresented: $state.isCreateSheetPresented) {
                    ExerciseEditSheet($state.editedExercise, onDone: {
                        state.onCreateExercise(workout: workout)
                        modelContext.insert(state.editedExercise)
                    }, onCancel: state.hideExerciseCreateSheet)
                }
                .sheet(isPresented: $state.isEditSheetPresented) {
                    ExerciseEditSheet($state.editedExercise, onDone: state.onUpdateExercise, onCancel: state.hideExerciseEditSheet)
                }
                .sheet(isPresented: $workoutState.isWorkoutEditSheetPresented) {
                    WorkoutEditSheet(Binding<Workout?> (get: { workoutState.editedWorkout }, set: { _ in }), onDone: {
                        workoutState.onUpdateWorkout()
                    }, onCancel: workoutState.hideWorkoutEditSheet)
                }
                .environment(\.editMode, $editMode).animation(.spring(), value: $editMode.wrappedValue)
                
                if (workout.exercises).count > 0 {
                    StartButton(isRunning: $state.isRunning, start: {
                        editMode = .inactive
                        state.start()
                    }, stop: state.stop)
                }
            }
            .ignoresSafeArea(.container, edges: [.bottom])
        }
    }
}
