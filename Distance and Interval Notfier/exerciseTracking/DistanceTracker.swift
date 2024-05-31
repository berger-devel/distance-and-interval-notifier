//
//  DistanceTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.05.24.
//

import Foundation
import CoreLocation


class DistanceTracker {
    
    private var clBackgroundActivitySession: CLBackgroundActivitySession? = nil
    private let userNotifier = UserNotifier()
    
    private var distance = 0.0
    private var notificationDistance = 0.0
    private var notification = 1.0
    
    private var exercises: ArraySlice<Exercise> = []
    private var exerciseIndex: Int = 0
    private var onUpdate: (Exercise?, Double) -> () = { _, _ in }
    
    private var lastLocations: [CLLocation] = []
    private var lastMovingAvgLocation = CLLocation()
    private var passage = 1
    private var trackingTask: Task<(), Never> = Task {}
    private var isTracking = false
    
    func track(exercises: ArraySlice<Exercise>, onUpdate: @escaping (Exercise?, Double) -> ()) async -> Bool {
        self.exercises = exercises
        self.onUpdate = onUpdate
        
        lastLocations = []
        
        if let exerciseIndex = exercises.indices.first {
            self.exerciseIndex = exerciseIndex
            passage = 1
            initNotificationParameters()
            
            trackingTask = Task {
                do {
                    clBackgroundActivitySession = CLBackgroundActivitySession()
                    onUpdate(exercises[exerciseIndex], 0)
                    
                    let updates = CLLocationUpdate.liveUpdates()
                    for try await update in updates {
                        if let location = update.location {
                            lastLocations.append(location)
                        }
                        
                        if lastLocations.count == 3 {
                            lastMovingAvgLocation = calculateMovingAverage()
                        } else if lastLocations.count > 3 {
                            let avgLocation = calculateMovingAverage()
                            await updateDistance(exerciseName: exercises[exerciseIndex].appearance.name, distance: avgLocation.distance(from: lastMovingAvgLocation))
                            lastMovingAvgLocation = avgLocation
                        }
                    }
                } catch {
                    Log.error("Error updating location", error)
                }
            }
            await trackingTask.value
        }
        
        return isTracking
    }
    
    func stop(startNext: Bool) {
        trackingTask.cancel()
        clBackgroundActivitySession?.invalidate()
        onUpdate(nil, 0)
        self.isTracking = startNext
    }
    
    private func initNotificationParameters() {
        distance = 0.0
        notification = 1.0
        notificationDistance = (exercises[exerciseIndex].unit == .METER ? exercises[exerciseIndex].amount : exercises[exerciseIndex].amount * 1000) / Double(exercises[exerciseIndex].notificationFrequency.rawValue + 1)
    }
    
    private func calculateMovingAverage() -> CLLocation {
        let clLocation = lastLocations.suffix(3).reduce(CLLocation(latitude: 0.0, longitude: 0.0), {(sum, location) in
            return CLLocation(
                latitude: sum.coordinate.latitude + location.coordinate.latitude,
                longitude: sum.coordinate.longitude + location.coordinate.longitude
            )
        })
        
        return CLLocation(latitude: clLocation.coordinate.latitude / 3, longitude: clLocation.coordinate.longitude / 3)
    }
    
    private func updateDistance(exerciseName: String, distance: Double) async {
        self.distance += distance
        let notificationAmount = notificationDistance * notification
        let finishAmount = exercises[exerciseIndex].unit == .METER ? exercises[exerciseIndex].amount : exercises[exerciseIndex].amount * 1000
        
        let (kilometers, meters) = Converter.toKilometers(amount: notificationAmount)
        if (self.distance >= finishAmount) {
            if passage < exercises[exerciseIndex].repetitionFrequency {
                await self.userNotifier.notify(title: exerciseName, meters: meters, kilometers: kilometers, nextExerciseIndex: exerciseIndex)
                passage += 1
                initNotificationParameters()
            } else {
                exerciseIndex += 1
                
                if exerciseIndex == exercises.indices.upperBound {
                    stop(startNext: true)
                    await self.userNotifier.notify(title: exerciseName, meters: meters, kilometers: kilometers, nextExerciseIndex: exerciseIndex)
                } else {
                    passage = 1
                    initNotificationParameters()
                }
            }
        } else {
            onUpdate(exercises[exerciseIndex], self.distance)
            
            if (self.distance >= notificationAmount) {
                await self.userNotifier.notify(title: exerciseName, meters: meters, kilometers: kilometers)
                self.notification += 1.0
            }
        }
    }
}
