//
//  Distance_and_Interval_NotfierApp.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 07.08.22.
//

import SwiftUI
import SwiftData

@main
struct Distance_and_Interval_NotfierApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, Exercise.self])
    }
}
