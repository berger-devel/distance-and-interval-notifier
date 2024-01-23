//
//  Preview.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 01.10.22.
//

import Foundation
import SwiftUI
import CoreData

struct Preview<Content: View>: View {
    
    private let content: Content
    
    private let workoutStorage: WorkoutStorage
    
    init(_ model: (NSManagedObjectContext) -> Void, @ViewBuilder _ content: () -> Content) {
        self.workoutStorage = WorkoutStorage(inMemory: true)
        model(workoutStorage.persistentContainer.viewContext)
        
        self.content = content()
    }
    
    var body: some View {
        content
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
