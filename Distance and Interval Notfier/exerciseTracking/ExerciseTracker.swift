//
//  ExerciseTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 26.03.23.
//

import Foundation
import UserNotifications
import CoreLocation

class ExerciseTracker {
    
    static let instance = ExerciseTracker()
    
    private let userNotifier = UserNotifier()
    private let userNotificationCenterDelegate = UserNotificationCenterDelegate()
    private let clLocationManager = CLLocationManager()
    private let locationManagerDelegate = LocationManagerDelegate()
    
    private let timeTracker = TimeTracker()
    
    private var exercises: [Exercise] = []
    
    private var onUpdate: (Exercise?, Double) -> () = { _, _ in }
    private var onFinish: () -> () = { }
    
    func start(_ exercises: [Exercise], onFinish: @escaping () -> (), onUpdate: @escaping (Exercise?, Double) -> ()) {
        userNotifier.cancel()
        
        Task {
            do {
                UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                Log.error("Error requesting notificaton authorizatino", error)
            }
            
            if let _ = exercises.first(where: { exercise in exercise.unit.quantity == .DISTANCE || exercise.announceBothQuantities }) {
                clLocationManager.delegate = locationManagerDelegate
                locationManagerDelegate.onAuthorize = {
                    self.clLocationManager.requestAlwaysAuthorization()
                }
                clLocationManager.requestWhenInUseAuthorization()
            }
        }
        
        self.exercises = exercises
        self.onFinish = onFinish
        self.onUpdate = onUpdate
        
        nextExerciseGroup(nextExerciseIndex: 0)
    }
    
    func nextExerciseGroup(nextExerciseIndex: Int) {
        let isPureTimeExercise: (Exercise) -> Bool = { exercise in exercise.unit.quantity == .TIME && !exercise.announceBothQuantities}
        if nextExerciseIndex < exercises.count {
            Task {
                if isPureTimeExercise(exercises[nextExerciseIndex]) {
                    let endIndex = exercises[nextExerciseIndex...].firstIndex(where: { exercise in exercise.unit.quantity == .DISTANCE || exercise.announceBothQuantities }) ?? exercises.count
                    let startNext: Bool
                    if exercises[nextExerciseIndex].announceBothQuantities {
                        startNext = await DistanceTracker.instance.track(exercises: exercises[nextExerciseIndex..<endIndex], onUpdate: onUpdate)
                    } else {
                        startNext = await timeTracker.track(exercises: exercises[nextExerciseIndex..<endIndex], onUpdate: onUpdate)
                    }
                    if startNext {
                        nextExerciseGroup(nextExerciseIndex: endIndex)
                    }
                } else if exercises[nextExerciseIndex].unit.quantity == .TIME, let nextPureTimeExerciseIndex = exercises[nextExerciseIndex...].firstIndex(where: isPureTimeExercise) {
                    let endIndex = exercises[(nextExerciseIndex + 1)...].firstIndex(where: { exercise in exercise.unit.quantity == .DISTANCE }) ?? exercises.count
                    
                    if true {
                        let initialDelay = exercises[nextExerciseIndex..<nextPureTimeExerciseIndex].reduce(0.0, { sum, exercise in sum + Converter.toSeconds(exercise.amount, from: exercise.unit) })
                        let timeTrackerTask = Task {
                            await timeTracker.track(exercises: exercises[nextPureTimeExerciseIndex..<endIndex], onUpdate: onUpdate, initialDelay: initialDelay)
                        }
                        if await DistanceTracker.instance.track(exercises: exercises[nextExerciseIndex..<nextPureTimeExerciseIndex], onUpdate: onUpdate) {
                            if await timeTrackerTask.value {
                                nextExerciseGroup(nextExerciseIndex: endIndex)
                            }
                        }
                    }
                } else {
                    let endIndex = exercises[nextExerciseIndex...].firstIndex(where: isPureTimeExercise) ?? exercises.count
                    if await DistanceTracker.instance.track(exercises: exercises[nextExerciseIndex..<endIndex], onUpdate: onUpdate) {
                        nextExerciseGroup(nextExerciseIndex: endIndex)
                    }
                }
            }
        } else {
            onFinish()
        }
    }
    
    func stop() {
        userNotifier.cancel()
        timeTracker.stop()
        DistanceTracker.instance.stop(startNext: false)
        onFinish()
    }
}
