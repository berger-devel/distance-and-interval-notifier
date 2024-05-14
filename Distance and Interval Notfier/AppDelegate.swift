//
//  AppDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.08.22.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SoundsDirectoryManager.createSoundsDirectory()
        SoundsDirectoryManager.initCleanupTimer()
        return true
    }
}
