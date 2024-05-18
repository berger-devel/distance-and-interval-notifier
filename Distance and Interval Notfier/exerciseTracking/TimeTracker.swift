//
//  TimeTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.05.24.
//

import Foundation

class TimeTracker {
    
    private let userNotifier = UserNotifier()
    
    private var isTracking = false
    
    func track(exercise: Exercise, onFinish: @escaping () -> (), onUpdate: @escaping(Double) -> ()) {
        isTracking = true
        
        let notificationFrequency = exercise.notificationFrequency.rawValue + 1
        for i in 1...notificationFrequency {
            Task {
                await userNotifier.notify(amount: round(exercise.amount / Double(notificationFrequency) * Double(i)), unit: exercise.unit)
            }
        }
        
        Task {
            let startTime = ContinuousClock.now
            let exerciseDuration = Duration(secondsComponent: Int64(exercise.amount), attosecondsComponent: 0)
            var elapsed = Duration(secondsComponent: 0, attosecondsComponent: 0)
            while(isTracking && elapsed < exerciseDuration) {
                onUpdate((Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) * 1e-18).rounded())
                
                try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                elapsed = ContinuousClock.now - startTime
            }
            
            onFinish()
        }
    }
    
    func stop() {
        isTracking = false
    }
}
