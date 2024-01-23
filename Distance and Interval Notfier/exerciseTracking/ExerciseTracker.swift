//
//  ExerciseTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 26.03.23.
//

import Foundation

class ExerciseTracker {
    private var locationManager: LocationManager = LocationManager()
    private let userNotifier = UserNotifier()
    
    private var distance: Double = 0.0
    
    private var exerciseIterator: IndexingIterator<[UIExercise]>?
    private var finishCallback: (() -> ())?
    
    func start(_ exercises: [UIExercise], onFinish finishCallback: @escaping () -> ()) {
        exerciseIterator = exercises.makeIterator()
        self.finishCallback = finishCallback
        let firstExercise = exerciseIterator!.next()!
        
        if firstExercise.unit.quantity == .TIME {
            userNotifier.alert(after: Double(firstExercise.amount), unit: firstExercise.unit, intervals: Int(firstExercise.notificationFrequency.rawValue) + 1, onFinish: onTimeExerciseFinish)
        } else {
            locationManager.setDistanceCallback(createUpdateDistanceCallback(exerciseDistance: firstExercise.amount, unit: firstExercise.unit))
            locationManager.start()
        }
    }
    
    func stop() {
        locationManager.stop()
    }
    
    private func onTimeExerciseFinish() {
        if let exercise = exerciseIterator?.next() {
            userNotifier.alert(after: exercise.amount, unit: exercise.unit, intervals: Int(exercise.notificationFrequency.rawValue) + 1, onFinish: onTimeExerciseFinish)
        } else {
            finishCallback!()
        }
    }
    
    private func createUpdateDistanceCallback(exerciseDistance: Double, unit: Unit) -> (Double) -> () {
        return { [self] distance in
            self.distance += distance
            
            if (self.distance > exerciseDistance) {
                if let nextExercise = exerciseIterator!.next() {
                    userNotifier.alert(distance: exerciseDistance, unit: unit)
                    self.distance = 0
                    if nextExercise.unit.quantity == .TIME {
                        userNotifier.alert(after: Double(nextExercise.amount), unit: nextExercise.unit, intervals: Int(nextExercise.notificationFrequency.rawValue) + 1, onFinish: finishCallback!)
                    } else {
                        locationManager.setDistanceCallback(createUpdateDistanceCallback(exerciseDistance: nextExercise.amount, unit: nextExercise.unit))
                    }
                } else {
                    stop()
                    finishCallback!()
                }
            }
        }
    }
}
