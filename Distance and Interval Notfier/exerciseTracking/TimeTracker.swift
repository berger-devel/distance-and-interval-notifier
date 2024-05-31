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
    
    func track(exercises: ArraySlice<Exercise>, onUpdate: @escaping(Exercise?, Double) -> ()) async -> Bool {
        isTracking = true
        scheduleNotifications(exercises: exercises)
        return await scheduleUIUpdates(exercises: exercises, onUpdate: onUpdate)
    }
    
    func stop() {
        isTracking = false
    }
    
    private func scheduleNotifications(exercises: ArraySlice<Exercise>) {
        var delay = 0.0
        exercises.forEach { exercise in
            for _ in 0..<exercise.repetitionFrequency {
                let notificationFrequency = exercise.notificationFrequency.rawValue + 1
                let period = exercise.amount * pow(60, exercise.unit.rawValue) / Double(notificationFrequency)
                for i in 1...notificationFrequency {
                    var seconds = round(period * Double(i))
                    delay += period
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
                    
                    { delay, seconds, minutes, hours, nextExerciseIndex -> () in
                        Task {
                            await userNotifier.notify(delay: delay, title: exercise.appearance.name, seconds: seconds, minutes: minutes, hours: hours, nextExerciseIndex: nextExerciseIndex)
                        }
                    }(delay, seconds, minutes, hours, exercises.count)
                }
            }
        }
    }
    
    private func scheduleUIUpdates(exercises: ArraySlice<Exercise>,  onUpdate: @escaping (Exercise?, Double) -> ()) async -> Bool {
        for i in exercises.indices {
            for _ in 0..<exercises[i].repetitionFrequency {
                let startTime = ContinuousClock.now
                let exerciseDuration = Duration(secondsComponent: Int64(Converter.toSeconds(exercises[i].amount, from: exercises[i].unit)), attosecondsComponent: 0)
                var elapsed = Duration(secondsComponent: 0, attosecondsComponent: 0)
                while(isTracking && elapsed < exerciseDuration) {
                    onUpdate(exercises[i], (Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) * 1e-18).rounded())
                    
                    do {
                        try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                    } catch {
                        Log.error("Error suspending task", error)
                    }
                    elapsed = ContinuousClock.now - startTime
                }
            }
        }
        
        onUpdate(nil, 0)
        return isTracking
    }
}
