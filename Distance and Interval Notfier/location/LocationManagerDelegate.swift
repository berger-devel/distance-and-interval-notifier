//
//  LocationManagerDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import CoreLocation

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    var onAuthorize = { }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        onAuthorize()
    }
}
