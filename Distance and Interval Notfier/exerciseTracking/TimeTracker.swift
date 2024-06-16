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
    
    func track(exercises: ArraySlice<Exercise>, onUpdate: @escaping(Exercise?, Double) -> (), initialDelay: Double = 0.0) async -> Bool {
        isTracking = true
        scheduleNotifications(exercises: exercises, initialDelay: initialDelay)
        return await scheduleUIUpdates(exercises: exercises, onUpdate: onUpdate, initialDelay: initialDelay)
    }
    
    func stop() {
        isTracking = false
    }
    
    private func scheduleNotifications(exercises: ArraySlice<Exercise>, initialDelay: Double) {
        var delay = initialDelay
        exercises.forEach { exercise in
            for _ in 0..<exercise.repetitionFrequency {
                let notificationFrequency = exercise.notificationFrequency.rawValue + 1
                let period = exercise.amount * pow(60, exercise.unit.rawValue) / Double(notificationFrequency)
                for i in 1...notificationFrequency {
                    let secondsAmount = round(period * Double(i))
                    delay += period
                    let (seconds, minutes, hours) = Converter.toHours(secondsAmount)
                    let notificationDelay = delay
                    Task {
                        await userNotifier.notify(notificationDelay, exercise.appearance.name, seconds, minutes, hours)
                    }
                }
            }
        }
        
        do {
            let notificationDelay = delay + 3
            guard let workoutName = exercises.first?.workout?.appearance.name else {
                throw OptionalError.from("first time exercise workout name")
            }
            Task {
                await userNotifier.notifyOpenApp(workoutName, notificationDelay)
            }
        } catch {
            Log.error("Error notifying to open app", nil)
        }
    }
    
    private func scheduleUIUpdates(exercises: ArraySlice<Exercise>,  onUpdate: @escaping (Exercise?, Double) -> (), initialDelay: Double) async -> Bool {
        if initialDelay != 0.0 {
            do {
                try await Task.sleep(until: .now + .seconds(initialDelay))
            } catch {
                Log.error("Error suspending task for initial delay", error)
            }
        }
        
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
                        Log.error("Error suspending task for one second", error)
                    }
                    elapsed = ContinuousClock.now - startTime
                }
            }
        }
        
        onUpdate(nil, 0)
        return isTracking
    }
}
