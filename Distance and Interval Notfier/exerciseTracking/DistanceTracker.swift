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
    private var notifications = 0.0
    
    private var exercise = Exercise()
    private var onFinish: () -> () = { }
    private var onUpdate: (Double) -> () = { _ in }
    
    private var lastLocations: [CLLocation] = []
    private var lastMovingAvgLocation = CLLocation()
    
    private var isTracking = false
    
    func track(exercise: Exercise, onFinish: @escaping () -> (), onUpdate: @escaping (Double) -> ()) {  
        isTracking = true
        
        distance = 0.0
        notifications = 1.0
        
        self.exercise = exercise
        self.onFinish = onFinish
        self.onUpdate = onUpdate
        
        lastLocations = []
        
        calculateNotificationDistance()
        
        clBackgroundActivitySession = CLBackgroundActivitySession()
        Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !isTracking {
                        clBackgroundActivitySession?.invalidate()
                        break
                    }
                    
                    if let location = update.location {
                        lastLocations.append(location)
                    }
                    
                    if lastLocations.count == 3 {
                        lastMovingAvgLocation = calculateMovingAverage()
                    } else  if lastLocations.count > 3 {
                        let avgLocation = calculateMovingAverage()
                        updateDistance(distance: avgLocation.distance(from: lastMovingAvgLocation))
                        lastMovingAvgLocation = avgLocation
                    }
                }
            } catch {
                Log.error("Error updating location", error)
            }
        }
    }
    
    func stop() {
        isTracking = false
    }
    
    private func calculateNotificationDistance() {
        notificationDistance = exercise.amount / Double(exercise.notificationFrequency.rawValue + 1)
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
    
    private func updateDistance(distance: Double) {
        self.distance += distance
        
        self.onUpdate(self.distance)
        
        if (self.distance >= self.notificationDistance * self.notifications) {
            Task {
                await self.userNotifier.notify(amount: self.distance, unit: .METER)
            }
            self.notifications += 1.0
        }
        
        if (self.distance >= exercise.amount) {
            self.stop()
            onFinish()
        }
    }
}
