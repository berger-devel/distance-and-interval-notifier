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
    
    private let userNotifier = UserNotifier()
    private let userNotificationCenterDelegate = UserNotificationCenterDelegate()
    private let clLocationManager = CLLocationManager()
    private let locationManagerDelegate = LocationManagerDelegate()
    
    private let timeTracker = TimeTracker()
    private let distanceTracker = DistanceTracker()
    
    private var distance: Double = 0.0
    
    private var exerciseIterator: IndexingIterator<[Exercise]>?
    private var onFinish: () -> () = { }
    private var onUpdate: (Double) -> () = { _ in }
    
    func start(_ exercises: [Exercise], onFinish: @escaping () -> (), onUpdate: @escaping (Double) -> ()) {
        userNotifier.cancel()
        
        Task {
            do {
                UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                Log.error("Error requesting notificaton authorizatino", error)
            }
            
            if !exercises.filter({ exercise in exercise.unit.quantity == .DISTANCE }).isEmpty {
                clLocationManager.delegate = locationManagerDelegate
                locationManagerDelegate.onAuthorize = {
                    self.clLocationManager.requestAlwaysAuthorization()
                }
                clLocationManager.requestWhenInUseAuthorization()
            }
        }
        
        exerciseIterator = exercises.makeIterator()
        self.onFinish = onFinish
        self.onUpdate = onUpdate
        
        nextExercise()
    }
    
    func nextExercise() {
        if let nextExercise = exerciseIterator?.next() {
            if nextExercise.unit.quantity == .TIME {
                timeTracker.track(exercise: nextExercise, onFinish: self.nextExercise, onUpdate: onUpdate)
            } else {
                distanceTracker.track(exercise: nextExercise, onFinish: self.nextExercise, onUpdate: onUpdate)
            }
        } else {
            onFinish()
        }
    }
    
    func stop() {
        userNotifier.cancel()
        timeTracker.stop()
        distanceTracker.stop()
        onFinish()
    }
}
