//
//  ExerciseList.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.08.22.
//

import Foundation
import SwiftUI
import os
import CoreData

struct ExerciseList: View {
    
    @Environment(\.managedObjectContext)
    private var context: NSManagedObjectContext
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @Environment(\.editMode)
    private var editMode
    
    private let persistenceManager: ExercisePersistenceManager
    private let workoutPersistenceManger: WorkoutPersistenceManager
    
    var workout: Workout?
    
    @Binding
    private var exercises: [UIExercise]
    
    @State
    private var newWorkout = CurrentWorkout()
    @State
    private var currentWorkout: CurrentWorkout = CurrentWorkout()
    
    @State
    private var selectedExercise = UIExercise()
    
    @State
    private var exerciseTracker = ExerciseTracker()
    
    private let formerValues: [UUID : UIExercise]
    
    @Binding
    private var isNewWorkoutSheetPresented: Bool
    @State
    private var isWorkoutEditSheetPresented = false
    
    @State
    private var isEditSheetPresented = false
    
    @State
    private var isCreating = false
    
    @State
    private var isRunning = false
    
    @State
    private var progress = 0.0
    
    init(workout: Workout, exercises: Binding<[UIExercise]>, formerValues: [UUID : UIExercise]) {
        self.workout = workout
        persistenceManager = ExercisePersistenceManager()
        workoutPersistenceManger = WorkoutPersistenceManager()
        self._exercises = exercises
        self.formerValues = formerValues
        self._isNewWorkoutSheetPresented = Binding(get: { false }, set: { _ in })
    }
    
    init(_ isNewWorkoutSheetPresented: Binding<Bool>) {
        persistenceManager = ExercisePersistenceManager()
        workoutPersistenceManger = WorkoutPersistenceManager()
        self._exercises = Binding(get: { [] }, set: { _ in })
        self.formerValues = [:]
        self._isNewWorkoutSheetPresented = isNewWorkoutSheetPresented
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ColorScheme.BACKGROUND_COLOR(colorScheme).ignoresSafeArea(.all)
                    List {
                        ForEach(exercises, id: \.self) { exercise in
                            Button(action: {
                                isCreating = false
                                isEditSheetPresented = true
                                selectedExercise = exercise
                            }) {
                                ExerciseListItem(
                                    Binding(get: { exercise }, set: { _ in }),
                                    Binding(get: { progress }, set: { _ in })
                                )
                            }
                            .foregroundColor(ColorScheme.LIST_ITEM_TEXT_COLOR)
                        }
                        .onDelete { indexSet in
                            persistenceManager.delete(workout!.exercises![indexSet.first!] as! Exercise, of: workout!, context)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Icon(sfSymbol: workout!.sfSymbol!, color: ColorScheme.ICON_COLOR(Int(workout!.colorIndex)), small: true)
                                Text(workout!.name!)
                                    .lineLimit(1)
                            }
                        }
                        
                        ToolbarItem {
                            Button(action: {
                                currentWorkout = CurrentWorkout.from(workout!)
                                isWorkoutEditSheetPresented = true
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
                                    selectedExercise = UIExercise()
                                    isCreating = true
                                    isEditSheetPresented = true
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isEditSheetPresented) {
                        NavigationStack {
                            ExerciseEditSheet($selectedExercise, formerValues: formerValues[selectedExercise.exerciseId])
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button(action: {
                                        saveExercise()
                                        isEditSheetPresented = false
                                    }) {
                                        Text("Done")
                                    }
                                }
                                
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(action: {
                                        isEditSheetPresented = false
                                    }) {
                                        Text("Cancel")
                                    }
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isWorkoutEditSheetPresented) {
                        WorkoutEditSheet($currentWorkout, $isWorkoutEditSheetPresented) {
                            workoutPersistenceManger.updateWorkout(workout!, from: currentWorkout, context)
                        }
                    }
                    .sheet(isPresented: $isNewWorkoutSheetPresented) {
                        WorkoutEditSheet($newWorkout, $isNewWorkoutSheetPresented) {
                            workoutPersistenceManger.addWorkout(newWorkout, context)
                        }
                    }
                    
                    if (workout?.exercises ?? []).count > 0 {
                        StartButton(isRunning: $isRunning, start: start, stop: stop)
                    }
            }
            .ignoresSafeArea(.container, edges: [.bottom])
        }
    }
    
    func saveExercise() {
        if isCreating {
            persistenceManager.add(selectedExercise, to: workout!, context)
        } else {
            if selectedExercise.unit == formerValues[selectedExercise.exerciseId]?.unit {
                selectedExercise.amount = selectedExercise.changedAmount
            }
            persistenceManager.update(selectedExercise, of: workout!, context)
        }
    }
    
    func start() {
        self.isRunning = true
        exerciseTracker.start(exercises, onFinish: {
            isRunning = false
        }, onUpdate: { progress in
            self.progress = progress
        })
    }
    
    func stop() {
        exerciseTracker.stop()
        isRunning = false
    }
    
    func onExerciseFinish() {
        isRunning = false
    }
}

struct ExerciseList_Previews: PreviewProvider {
    private static let workoutStorage = WorkoutStorage.preview
    private static let workout = {
        let context = workoutStorage.persistentContainer.viewContext
        let workout = Workout.from(CurrentWorkout(name: "A Workout", sfSymbol: "hands.clap", colorIndex: 0), context: context)
        for _ in 0 ... 2 {
            Exercise(context: context).workout = workout
        }
        return workout
    }()
    
    static var previews: some View {
        ExerciseList(workout: workout, exercises: Binding(
            get: { workout.exercises!.map({ exercise in UIExercise(from: exercise as! Exercise) }) },
            set: { _ in }
        ), formerValues: (workout.exercises!.array as! [Exercise]).reduce(into: [:], { dict, exercise in
            dict[exercise.id!] = UIExercise(from: exercise) })
        )
    }
}
