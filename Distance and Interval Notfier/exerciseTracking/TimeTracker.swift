//
//  TimeTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.05.24.
//

import Foundation

class TimeTracker {
    
    private let userNotifier = UserNotifier()
    
    private var elapsedSeconds = 0.0
    private var updateTimer: Timer? = nil
    
    func track(exercise: UIExercise, onFinish: @escaping () -> (), onUpdate: @escaping(Double) -> ()) {
        let notificationFrequency = exercise.notificationFrequency.rawValue + 1
        let interval = exercise.amount / Double(notificationFrequency)
        
        for i in 1...notificationFrequency {
            userNotifier.notify(exercise: exercise, interval: interval * Double(i))
        }
        
        elapsedSeconds = 1.0
        DispatchQueue.main.async { [self] in
            updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
                onUpdate(elapsedSeconds)
                elapsedSeconds += 1
                if elapsedSeconds > exercise.amount {
                    timer.invalidate()
                }
            }
        }
    }
    
    func stop() {
        userNotifier.cancel()
        updateTimer?.invalidate()
    }
}
