//
//  DistanceTracker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.05.24.
//

import Foundation
import CoreLocation

class DistanceTracker {
    
    static let instance = DistanceTracker()
    
    private static let MOVING_AVG_POINTS = 3
    private static let DISCARD_LOCATION_UPDATES_OLDER_THAN_SECONDS = 2.0
    
    private var clBackgroundActivitySession: CLBackgroundActivitySession? = nil
    private let userNotifier = UserNotifier()
    
    private var distance = 0.0
    private var notificationInterval = 0.0
    private var finishAmount = 0.0
    private var notification = 1.0
    private var startTime: ContinuousClock.Instant?
    private var elapsedTime: Double?
    
    private var exercises: ArraySlice<Exercise> = []
    private var exerciseIndex: Int = 0
    private var onUpdate: (Exercise?, Double) -> () = { _, _ in }
    
    private var lastLocations: [CLLocation] = []
    private var lastMovingAvgLocation = CLLocation()
    private var passage = 1
    
    private var trackingTask: Task<(), Never> = Task {}
    private var isTracking = false
    
    private var updateDistanceFn: () async -> () = { }
    
    private init() { }
    
    func track(exercises: ArraySlice<Exercise>, onUpdate: @escaping (Exercise?, Double) -> ()) async -> Bool {
        self.exercises = exercises
        self.onUpdate = onUpdate
        updateDistanceFn = countLocationUpdates
        
        lastLocations = []
        
        if let exerciseIndex = exercises.indices.first {
            self.exerciseIndex = exerciseIndex
            
            initNotificationParameters()
            passage = 1
            
            trackingTask = Task {
                do {
                    clBackgroundActivitySession = CLBackgroundActivitySession()
                    onUpdate(exercises[exerciseIndex], 0)
                    
                    let updates = CLLocationUpdate.liveUpdates()
                    for try await update in updates {
                        if let location = update.location {
                            
                            if location.timestamp.timeIntervalSinceNow < -Self.DISCARD_LOCATION_UPDATES_OLDER_THAN_SECONDS {
                                continue
                            }
                            if let startTime {
                                elapsedTime = Double((ContinuousClock.now - startTime).components.seconds)
                            }
                            
                            lastLocations.append(location)
                            
                            await updateDistanceFn()
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
        startTime = nil
        elapsedTime = nil
        onUpdate(nil, 0)
        self.isTracking = startNext
    }
    
    private func initNotificationParameters() {
        if exercises[exerciseIndex].announceBothQuantities {
            startTime = ContinuousClock.now
        }
        
        distance = 0.0
        
        if exercises[exerciseIndex].unit.quantity == .TIME {
            finishAmount = switch(exercises[exerciseIndex].unit) {
            case .HOUR: exercises[exerciseIndex].amount * 3600
            case .MINUTE: exercises[exerciseIndex].amount * 60
            default: exercises[exerciseIndex].amount
            }
        } else {
            finishAmount = exercises[exerciseIndex].unit == .METER ? exercises[exerciseIndex].amount : exercises[exerciseIndex].amount * 1000
        }
        
        notificationInterval = finishAmount / Double(exercises[exerciseIndex].notificationFrequency.rawValue + 1)
        notification = 1.0
    }
    
    private func countLocationUpdates() {
        if lastLocations.count == Self.MOVING_AVG_POINTS {
            lastMovingAvgLocation = calculateMovingAverage()
            updateDistanceFn = initDistance
        }
    }
    
    private func initDistance() async {
        let avgLocation = calculateMovingAverage()
        distance = Double(Self.MOVING_AVG_POINTS) * avgLocation.distance(from: lastMovingAvgLocation)
        lastMovingAvgLocation = avgLocation
        updateDistanceFn = updateDistance
        await notify()
    }
    
    private func updateDistance() async {
        let avgLocation = calculateMovingAverage()
        self.distance += avgLocation.distance(from: lastMovingAvgLocation)
        lastMovingAvgLocation = avgLocation
        lastLocations.removeFirst()
        await notify()
    }
    
    private func calculateMovingAverage() -> CLLocation {
        let clLocation = lastLocations.suffix(Self.MOVING_AVG_POINTS).reduce(CLLocation(latitude: 0.0, longitude: 0.0), {(sum, location) in
            return CLLocation(
                latitude: sum.coordinate.latitude + location.coordinate.latitude,
                longitude: sum.coordinate.longitude + location.coordinate.longitude
            )
        })
        
        return CLLocation(latitude: clLocation.coordinate.latitude / Double(Self.MOVING_AVG_POINTS), longitude: clLocation.coordinate.longitude / Double(Self.MOVING_AVG_POINTS))
    }
    
    func notify() async {
        let notificationAmount = notificationInterval * notification

        if exercises[exerciseIndex].unit.quantity == .TIME {
            guard let startTime else {
                Log.error("Error measuring time", nil)
                return
            }
            
            let (meters, kilometers) = Converter.toKilometers(self.distance)
            
            if ContinuousClock.now >= startTime + Duration(secondsComponent: Int64(finishAmount), attosecondsComponent: 0) {
                let (seconds, minutes, hours) = Converter.toHours(notificationAmount)
                await userNotifier.notify(exercises[exerciseIndex].appearance.name, seconds, minutes, hours, meters, kilometers)
                
                if passage < exercises[exerciseIndex].repetitionFrequency {
                    passage += 1
                    initNotificationParameters()
                } else {
                    exerciseIndex += 1
                    
                    if exerciseIndex == exercises.indices.upperBound {
                        stop(startNext: true)
                    } else {
                        passage = 1
                        initNotificationParameters()
                    }
                }
            } else {
                if let elapsedTime {
                    onUpdate(exercises[exerciseIndex], elapsedTime)
                    
                    if elapsedTime >= notificationAmount {
                        let (seconds, minutes, hours) = Converter.toHours(elapsedTime)
                        await userNotifier.notify(exercises[exerciseIndex].appearance.name, seconds, minutes, hours, meters, kilometers)
                        notification += 1
                    }
                }
            }
        } else {
            let (meters, kilometers) = Converter.toKilometers(notificationAmount)

            if self.distance >= finishAmount {
                if let elapsedTime {
                    let (seconds, minutes, hours) = Converter.toHours(elapsedTime)
                    await userNotifier.notify(exercises[exerciseIndex].appearance.name, meters, kilometers, seconds, minutes, hours)
                } else {
                    await userNotifier.notify(exercises[exerciseIndex].appearance.name, meters, kilometers)
                }
                
                if passage < exercises[exerciseIndex].repetitionFrequency {
                    passage += 1
                    initNotificationParameters()
                } else {
                    exerciseIndex += 1
                    
                    if exerciseIndex == exercises.indices.upperBound {
                        stop(startNext: true)
                    } else {
                        passage = 1
                        initNotificationParameters()
                    }
                }
            } else {
                onUpdate(exercises[exerciseIndex], self.distance)
                
                if self.distance >= notificationAmount {
                    if let elapsedTime {
                        let (seconds, minutes, hours) = Converter.toHours(elapsedTime)
                        await self.userNotifier.notify(exercises[exerciseIndex].appearance.name, meters, kilometers, seconds, minutes, hours)
                    } else {
                        await self.userNotifier.notify(exercises[exerciseIndex].appearance.name, meters, kilometers)
                    }
                    self.notification += 1.0
                }
            }
        }
    }
}
