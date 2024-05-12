//
//  LocationManagerDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 07.08.22.
//

import Foundation
import CoreLocation
import os
import AVFoundation
import SwiftUI

class LocationManager {
    
    private var locationManagerDelegate: LocationManagerDelegate
    private let clLocationManager: CLLocationManager
    
    init() {
        clLocationManager = CLLocationManager()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.allowsBackgroundLocationUpdates = true
        clLocationManager.distanceFilter = 1.5
        
        locationManagerDelegate = LocationManagerDelegate()
        clLocationManager.delegate = locationManagerDelegate
    }
    
    func setDistanceCallback(_ onUpdateDistance: @escaping (Double) -> ()) {
        locationManagerDelegate.updateDistance = onUpdateDistance
    }
    
    func start() {
        locationManagerDelegate.onAuthorize = {
            self.clLocationManager.requestAlwaysAuthorization()
        }
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.startUpdatingLocation()
    }
    
    func stop() {
        clLocationManager.stopUpdatingLocation()
    }
}
