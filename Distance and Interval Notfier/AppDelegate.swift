//
//  AppDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.08.22.
//

import Foundation
import UIKit
import os

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let userNotificationCenterDelegate = UserNotificationCenterDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
        SoundsDirectoryManager.createSoundsDirectory()
        SoundsDirectoryManager.initCleanupTimer()
        
        return true
    }
}
