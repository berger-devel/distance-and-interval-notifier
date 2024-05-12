//
//  DistanceTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.05.24.
//

import Foundation

class DistanceTracker {
    
    private let locationManager = LocationManager()
    private let userNotifier = UserNotifier()
    
    private var distance = 0.0
    private var notificationDistance = 0.0
    private var notifications = 0.0
    private var onUpdate: (Double) -> () = { _ in }
    
    func track(exercise: UIExercise, onFinish: @escaping () -> (), onUpdate: @escaping (Double) -> ()) {
        self.distance = 0.0
        self.notifications = 1.0
        
        self.onUpdate = onUpdate
        
        calculateNotificationDistance(exercise)
        
        locationManager.setDistanceCallback(createUpdateDistanceCallback(exercise, onFinish))
        locationManager.start()
    }
    
    func stop() {
        locationManager.stop()
    }
    
    private func calculateNotificationDistance(_ exercise: UIExercise) {
        notificationDistance = exercise.amount
        if exercise.unit == .MINUTE {
            notificationDistance *= 60.0
        } else if exercise.unit == .HOUR {
            notificationDistance *= 360
        }
        notificationDistance /= Double(exercise.notificationFrequency.rawValue + 1)
    }
    
    private func createUpdateDistanceCallback(_ exercise: UIExercise, _ onFinish: @escaping () -> ()) -> (Double) -> () {
        return { distance in
            self.distance += distance
            
            self.onUpdate(self.distance)
            
            if (self.distance >= self.notificationDistance * self.notifications) {
                self.userNotifier.notify(exercise: exercise)
                self.notifications += 1.0
            }
            
            if (self.distance >= exercise.amount) {
                self.stop()
                onFinish()
            }
        }
    }
}
