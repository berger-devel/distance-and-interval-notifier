//
//  LocationManagerDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import CoreLocation
import SwiftUI
import os

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    private var lastLocations: [CLLocation] = []
    private var movingAvgLocations = CLLocation()
    private var milestone = 0.0
    
    private var updateLocation: (CLLocation) -> Void = { _ in }
    private var updateDistance: (Double) -> Void = { _ in }
    
    override init() {
        super.init()
        
        updateLocation = initialLocation(location:)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations: [CLLocation]) {
        updateLocation(didUpdateLocations.last!)
    }
    
    private func initialLocation(location: CLLocation) {
        lastLocations.append(location)
        updateLocation = updateLocation(location:)
    }
    
    private func updateLocation(location: CLLocation) {
        if lastLocations.count >= 3 {
            movingAvgLocations = calculateMovingAverage()
            updateLocation = updateAvgLocation(location:)
        }
        
        lastLocations.append(location)
    }
    
    private func updateAvgLocation(location: CLLocation) {
        let avgLocation = calculateMovingAverage()
        updateDistance(avgLocation.distance(from: movingAvgLocations))
        movingAvgLocations = avgLocation
        
        lastLocations.append(location)
    }
    
    private func calculateMovingAverage() -> CLLocation {
        return lastLocations.suffix(3).reduce(CLLocation(latitude: 0.0, longitude: 0.0), {(avg, location) in
            return CLLocation(
                latitude: avg.coordinate.latitude + location.coordinate.latitude / 3.0,
                longitude: avg.coordinate.longitude + location.coordinate.longitude / 3.0
            )
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger().log("error: \(error.localizedDescription)")
    }
    
    func setDistanceCallback(_ distanceCallback: @escaping (Double) -> Void) {
        updateDistance = distanceCallback
    }
}
