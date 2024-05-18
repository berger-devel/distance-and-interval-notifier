//
//  NotificationFrequencyPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.03.23.
//

import Foundation
import SwiftUI

struct NotificationFrequencyPicker: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Binding
    private var exercise: Exercise
    
    init(exercise: Binding<Exercise>) {
        self._exercise = exercise
    }
    
    var body: some View {
        Section("Notifications") {
            Toggle(isOn: $exercise.announceBothQuantities) {
                Text("Also announce \($exercise.unit.quantity.wrappedValue == .TIME ? Quantity.DISTANCE.description.lowercased() : Quantity.TIME.description.lowercased() )")
            }
        }
        .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
        Picker(selection: $exercise.notificationFrequency, label: Text("")) {
            Text(NotificationFrequency.ONCE.description).tag(NotificationFrequency.ONCE)
            Text(NotificationFrequency.TWICE.description).tag(NotificationFrequency.TWICE)
            Text(NotificationFrequency.THREE.description).tag(NotificationFrequency.THREE)
            Text(NotificationFrequency.FOUR.description).tag(NotificationFrequency.FOUR)
            Text(NotificationFrequency.FIVE.description).tag(NotificationFrequency.FIVE)
        }
        .pickerStyle(.wheel)
    }
}
