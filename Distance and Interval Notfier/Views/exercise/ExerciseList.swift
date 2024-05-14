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
            VStack(spacing: 0) {
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
                            do {
                                guard let workout = workout else {
                                    throw OptionalError.from("workout")
                                }
                                
                                if let index = indexSet.first {
                                    guard let exercise = workout.exercises?[index] as? Exercise else {
                                        throw OptionalError.from("exercise")
                                    }
                                    
                                    persistenceManager.delete(exercise, of: workout, context)
                                }
                            } catch {
                                Log.error("Error deleting exercise", error)
                            }
                        }
                        .onMove(perform: { indexSet, newPosition in
                            do {
                                guard let workout = workout else {
                                    throw OptionalError.from("workout")
                                }
                                
                                persistenceManager.move(indexSet, of: workout, to: newPosition, context)
                            } catch {
                                Log.error("Error moving exercise", error)
                            }
                        })
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                if let workout = workout {
                                    Icon(sfSymbol: workout.sfSymbol ?? "xmark", color: ColorScheme.ICON_COLOR(Int(workout.colorIndex)), small: true)
                                    Text(workout.name ?? "Error")
                                        .lineLimit(1)
                                }
                            }
                        }
                        
                        ToolbarItem {
                            Button(action: {
                                do {
                                    guard let workout = workout else {
                                        throw OptionalError.from("workout")
                                    }
                                    
                                    currentWorkout = CurrentWorkout.from(workout)
                                    isWorkoutEditSheetPresented = true
                                } catch {
                                    Log.error("Error presenting workout edit sheet", error)
                                }
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
                            do {
                                guard let workout = workout else {
                                    throw OptionalError.from("workout")
                                }
                                
                                workoutPersistenceManger.updateWorkout(workout, from: currentWorkout, context)
                            } catch {
                                Log.error("Error finishing workout update", error)
                            }
                        }
                    }
                    .sheet(isPresented: $isNewWorkoutSheetPresented) {
                        WorkoutEditSheet($newWorkout, $isNewWorkoutSheetPresented) {
                            workoutPersistenceManger.addWorkout(newWorkout, context)
                        }
                    }
                }
                
                if (workout?.exercises ?? []).count > 0 {
                    VStack {
                        Spacer()
                        StartButton(isRunning: $isRunning, start: start, stop: stop)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .background(ColorScheme.BACKGROUND_COLOR(colorScheme))
                    .ignoresSafeArea()
                }
            }
            .ignoresSafeArea(.container, edges: [.bottom])
        }
    }
    
    func saveExercise() {
        do {
            guard let workout = workout else {
                throw OptionalError.from("workout")
            }
            
            if isCreating {
                persistenceManager.add(selectedExercise, to: workout, context)
            } else {
                if selectedExercise.unit == formerValues[selectedExercise.exerciseId]?.unit {
                    selectedExercise.amount = selectedExercise.changedAmount
                }
                persistenceManager.update(selectedExercise, of: workout, context)
            }
        } catch {
            Log.error("Error saving exercise", error)
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
                    Log.error("Could not get exercises", error)
                    return []
                }
            },
            set: { _ in }
        ), formerValues: {
            do {
                guard let exercises = workout.exercises?.array as? [Exercise] else {
                    throw OptionalError.from("exercises")
                }
                
                return try exercises.reduce(into: [:], { dict, exercise in
                    guard let id = exercise.id else {
                        throw OptionalError.from("id")
                    }
                    
                    dict[id] = UIExercise(from: exercise) })
            } catch {
                Log.error("Could not take former values", error)
                return [:]
            }
        }())
    }
}
