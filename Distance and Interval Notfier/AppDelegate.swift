//
//  AppDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.08.22.
//

import Foundation
import UIKit
import AVFAudio
import os
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let userNotificationCenterDelegate = UserNotificationCenterDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initUserNotifications()
        SoundsDirectoryManager.createSoundsDirectory()
        SoundsDirectoryManager.initCleanupTimer()
        
        return true
    }
    
    private func initUserNotifications() {
        UNUserNotificationCenter.current().delegate = userNotificationCenterDelegate
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [.mixWithOthers, .duckOthers, .interruptSpokenAudioAndMixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logger().log("Error initializing audio: \(error.localizedDescription)")
        }
    }
}
