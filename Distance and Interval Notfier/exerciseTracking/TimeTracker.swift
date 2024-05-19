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
        
        Task {
            let duration = exercise.amount * pow(60, exercise.unit.rawValue)
            
            for i in 0..<exercise.repetitionFrequency {
                for j in 1...notificationFrequency {
                    var seconds = round(duration / Double(notificationFrequency) * Double(j))
                    let delay = Double(i) * duration + seconds
                    var minutes: Double?
                    var hours: Double?
                    if seconds >= 60.0 {
                        minutes = Double(Int(seconds / 60.0))
                        seconds = seconds.truncatingRemainder(dividingBy: 60.0)
                        
                        if minutes! >= 60.0 {
                            hours = Double(Int(minutes! / 60.0))
                            minutes = minutes?.truncatingRemainder(dividingBy: 60)
                        }
                        
                    }
                    
                    await userNotifier.notify(delay: delay, title: exercise.appearance.name, seconds: seconds, minutes: minutes, hours: hours)
                }
            }
            
            for _ in 0..<exercise.repetitionFrequency {
                let startTime = ContinuousClock.now
                let exerciseDuration = Duration(secondsComponent: Int64(duration), attosecondsComponent: 0)
                var elapsed = Duration(secondsComponent: 0, attosecondsComponent: 0)
                while(isTracking && elapsed < exerciseDuration) {
                    onUpdate((Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) * 1e-18).rounded())
                    
                    try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                    elapsed = ContinuousClock.now - startTime
                }
            }
            
            onUpdate(duration)
            onFinish()
        }
    }
    
    func stop() {
        isTracking = false
    }
}
