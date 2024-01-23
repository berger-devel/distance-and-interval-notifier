//
//  Distance_and_Interval_NotfierApp.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 07.08.22.
//

import SwiftUI

@main
struct Distance_and_Interval_NotfierApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let workoutStorage = WorkoutStorage.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, workoutStorage.persistentContainer.viewContext)
        }
    }
}
