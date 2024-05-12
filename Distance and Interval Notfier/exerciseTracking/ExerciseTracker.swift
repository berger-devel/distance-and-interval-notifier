//
//  ExerciseTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 26.03.23.
//

import Foundation
import UserNotifications

class ExerciseTracker {
    
    private let timeTracker = TimeTracker()
    private let distanceTracker = DistanceTracker()
    
    private var distance: Double = 0.0
    
    private var exerciseIterator: IndexingIterator<[UIExercise]>?
    private var onFinish: () -> () = { }
    private var onUpdate: (Double) -> () = { _ in }
    
    func start(_ exercises: [UIExercise], onFinish: @escaping () -> (), onUpdate: @escaping (Double) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [self] _,_ in 
            exerciseIterator = exercises.makeIterator()
            self.onFinish = onFinish
            self.onUpdate = onUpdate
            nextExercise()
        }
    }
    
    func nextExercise() {
        if let nextExercise = exerciseIterator?.next() {
            if nextExercise.unit.quantity == .TIME {
                timeTracker.track(exercise: nextExercise, onFinish: self.nextExercise, onUpdate: onUpdate)
            } else {
                distanceTracker.track(exercise: nextExercise, onFinish: onFinish, onUpdate: onUpdate)
            }
        } else {
            stop()
        }
    }
    
    func stop() {
        timeTracker.stop()
        distanceTracker.stop()
        onFinish()
    }
}
