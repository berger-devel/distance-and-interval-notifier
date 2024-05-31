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
    private let distanceTracker = DistanceTracker()
    
    private var exercises: [Exercise] = []
    
    private var onUpdate: (Exercise?, Double) -> () = { _, _ in }
    private var onFinish: () -> () = { }
    
    private init() { }
    
    func start(_ exercises: [Exercise], onFinish: @escaping () -> (), onUpdate: @escaping (Exercise?, Double) -> ()) {
        userNotifier.cancel()
        
        Task {
            do {
                UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                Log.error("Error requesting notificaton authorizatino", error)
            }
            
            if let _ = exercises.first(where: { exercise in exercise.unit.quantity == .DISTANCE }) {
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
        if nextExerciseIndex < exercises.count {
            Task {
                if exercises[nextExerciseIndex].unit.quantity == .TIME {
                    let endIndex = exercises[nextExerciseIndex...].firstIndex(where: { exercise in exercise.unit.quantity == .DISTANCE }) ?? exercises.count
                    if await timeTracker.track(exercises: exercises[nextExerciseIndex..<endIndex], onUpdate: onUpdate) {
                        nextExerciseGroup(nextExerciseIndex: endIndex)
                    }
                } else {
                    let endIndex = exercises[nextExerciseIndex...].firstIndex(where: { exercise in exercise.unit.quantity == .TIME }) ?? exercises.count
                    if await distanceTracker.track(exercises: exercises[nextExerciseIndex..<endIndex], onUpdate: onUpdate) {
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
        distanceTracker.stop(startNext: false)
        onFinish()
    }
}
