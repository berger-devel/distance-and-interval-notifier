//
//  NotificationFrequencySection.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.03.23.
//

import Foundation
import SwiftUI

struct NotificationFrequencySection: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Binding
    private var exercise: Exercise
    
    init(exercise: Binding<Exercise>) {
        self._exercise = exercise
    }
    
    var body: some View {
        Section("Notifications") {
            Picker(selection: $exercise.notificationFrequency, label: Text("")) {
                ForEach(NotificationFrequency.allCases, id: \.self) { notificationFrequency in
                    Text(String(describing: notificationFrequency)).tag(notificationFrequency)
                }
            }
            .pickerStyle(.wheel)

            Toggle(isOn: $exercise.announceBothQuantities) {
                Text("Also announce \($exercise.unit.quantity.wrappedValue == .TIME ? String(describing: Quantity.DISTANCE).lowercased() : String(describing: Quantity.TIME).lowercased() )")
            }
        }
        .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
    }
}
