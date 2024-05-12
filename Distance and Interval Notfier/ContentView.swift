//
//  ContentView.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 07.08.22.
//

import os
import SwiftUI
import CoreLocation

struct ContentView: View {
    var body: some View {
        WorkoutList()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let workoutStorage = WorkoutStorage.preview
//        Preview({ context in
//            PreviewWorkouts.twoWorkoutsThreeExercises(context)
//        }) {
        ContentView()
            .environment(\.managedObjectContext, workoutStorage.persistentContainer.viewContext)
//        }
    }
}
